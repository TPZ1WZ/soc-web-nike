"""
AI Investigation Assistant — FastAPI backend.
- Giao diện web (static/index.html)
- /api/analyze : phân tích 1 alert (RAG + LLM) -> báo cáo sự cố
- /api/alerts  : kéo alert web_attack mới nhất từ Wazuh Indexer
- /api/ingest  : webhook nhận alert từ Wazuh integrator -> tự phân tích -> Telegram
"""
import os
import json
import asyncio
import urllib3
import requests
from fastapi import FastAPI, Body
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from dotenv import load_dotenv

from rag import kb
from prompts import SYSTEM_PROMPT, build_analysis_prompt
import llm

load_dotenv()
urllib3.disable_warnings()  # bỏ cảnh báo TLS tự ký của Wazuh Indexer

app = FastAPI(title="AI Investigation Assistant")
HERE = os.path.dirname(__file__)


# ---------- Helpers ----------
def build_query(alert: dict) -> str:
    """Ghép các trường quan trọng của alert thành câu truy vấn cho RAG."""
    rule = alert.get("rule", {})
    data = alert.get("data", {})
    parts = [
        rule.get("description", ""),
        " ".join(rule.get("groups", []) or []),
        data.get("event", ""),
        data.get("url", ""),
        alert.get("full_log", "")[:300],
    ]
    return " ".join(p for p in parts if p)


def analyze_alert(alert: dict) -> dict:
    query = build_query(alert) or json.dumps(alert)[:500]
    docs = kb.retrieve(query, k=4)
    prompt = build_analysis_prompt(json.dumps(alert, ensure_ascii=False, indent=2), docs)
    report = llm.analyze(SYSTEM_PROMPT, prompt)
    return {"report": report, "context": docs}


def send_telegram(text: str):
    token = os.getenv("TELEGRAM_BOT_TOKEN")
    chat = os.getenv("TELEGRAM_CHAT_ID")
    if not token or not chat:
        return False
    try:
        requests.post(
            f"https://api.telegram.org/bot{token}/sendMessage",
            json={"chat_id": chat, "text": text[:4000]}, timeout=10,
        )
        return True
    except Exception:
        return False


# ---------- AUTO MODE: poll Wazuh -> phân tích -> Telegram ----------
_SEEN_IDS = set()  # tránh phân tích trùng 1 alert


def fetch_new_alerts(limit=20, min_level=10):
    """Kéo alert web_attack mới nhất kèm _id để lọc trùng."""
    url = os.getenv("WAZUH_INDEXER_URL", "https://localhost:9200")
    auth = (os.getenv("WAZUH_INDEXER_USER", "admin"), os.getenv("WAZUH_INDEXER_PASS", "SecretPassword"))
    body = {
        "size": limit,
        "sort": [{"timestamp": {"order": "desc"}}],
        "query": {"bool": {
            "must": [{"range": {"rule.level": {"gte": min_level}}}],
            "should": [{"prefix": {"rule.id": "1001"}}, {"match": {"rule.groups": "web_attack"}}],
            "minimum_should_match": 1,
        }},
    }
    r = requests.get(f"{url}/wazuh-alerts-*/_search", json=body, auth=auth, verify=False, timeout=15)
    return r.json().get("hits", {}).get("hits", [])


async def auto_poller():
    interval = int(os.getenv("POLL_INTERVAL", "30"))
    min_level = int(os.getenv("MIN_LEVEL", "10"))
    print(f"[AUTO] Poller bật: mỗi {interval}s, alert level>={min_level} -> phân tích + Telegram")
    # Lần đầu: đánh dấu alert cũ là đã thấy (chỉ xử lý alert MỚI sau khi bật)
    try:
        for h in fetch_new_alerts(50, min_level):
            _SEEN_IDS.add(h.get("_id"))
    except Exception as e:
        print(f"[AUTO] init error: {e}")
    while True:
        await asyncio.sleep(interval)
        try:
            for h in reversed(fetch_new_alerts(20, min_level)):
                aid = h.get("_id")
                if aid in _SEEN_IDS:
                    continue
                _SEEN_IDS.add(aid)
                alert = h["_source"]
                print(f"[AUTO] Alert mới: {alert.get('rule', {}).get('description', '')[:60]}")
                result = await asyncio.to_thread(analyze_alert, alert)
                r = alert.get("rule", {})
                header = (f"🚨 SOC AI ALERT\nMức độ rule: level {r.get('level')}\n"
                          f"Máy: {alert.get('agent', {}).get('name', '?')}\n\n")
                send_telegram(header + result["report"])
        except Exception as e:
            print(f"[AUTO] poll error: {e}")


# ---------- API ----------
@app.on_event("startup")
async def _startup():
    n = kb.load()
    print(f"[RAG] Loaded {n} knowledge chunks.")
    if os.getenv("AUTO_MODE", "false").lower() == "true" and os.getenv("TELEGRAM_BOT_TOKEN"):
        asyncio.create_task(auto_poller())
    else:
        print("[AUTO] Tắt (đặt AUTO_MODE=true + TELEGRAM_BOT_TOKEN để bật).")


@app.get("/api/health")
def health():
    return {"status": "ok", "model": os.getenv("OPENAI_MODEL", "gpt-4o-mini")}


@app.post("/api/analyze")
def api_analyze(payload: dict = Body(...)):
    """Nhận {"alert": <json alert hoặc text>} -> trả báo cáo."""
    alert = payload.get("alert")
    if isinstance(alert, str):
        try:
            alert = json.loads(alert)
        except Exception:
            alert = {"full_log": alert}
    return analyze_alert(alert or {})


@app.get("/api/alerts")
def api_alerts(limit: int = 15):
    """Kéo các alert tấn công web mới nhất từ Wazuh Indexer (OpenSearch)."""
    url = os.getenv("WAZUH_INDEXER_URL", "https://localhost:9200")
    auth = (os.getenv("WAZUH_INDEXER_USER", "admin"), os.getenv("WAZUH_INDEXER_PASS", "SecretPassword"))
    body = {
        "size": limit,
        "sort": [{"timestamp": {"order": "desc"}}],
        "query": {"bool": {"should": [
            {"prefix": {"rule.id": "1001"}},
            {"match": {"rule.groups": "web_attack"}},
        ], "minimum_should_match": 1}},
    }
    try:
        r = requests.get(f"{url}/wazuh-alerts-*/_search", json=body, auth=auth,
                         verify=False, timeout=15)
        hits = r.json().get("hits", {}).get("hits", [])
        return {"count": len(hits), "alerts": [h["_source"] for h in hits]}
    except Exception as e:
        return {"count": 0, "alerts": [], "error": str(e)}


@app.post("/api/ingest")
def api_ingest(alert: dict = Body(...)):
    """Webhook cho Wazuh integrator: tự phân tích + gửi Telegram."""
    result = analyze_alert(alert)
    send_telegram("🚨 SOC AI ALERT\n\n" + result["report"])
    return result


# ---------- UI ----------
app.mount("/static", StaticFiles(directory=os.path.join(HERE, "static")), name="static")


@app.get("/")
def index():
    return FileResponse(os.path.join(HERE, "static", "index.html"))
