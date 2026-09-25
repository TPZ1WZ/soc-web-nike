"""
AI Investigation Assistant — FastAPI backend.
- Giao diện web (static/index.html)
- /api/analyze : phân tích 1 alert (RAG + LLM) -> báo cáo sự cố
- /api/alerts  : kéo alert web_attack mới nhất từ Wazuh Indexer
- /api/ingest  : webhook nhận alert từ Wazuh integrator -> tự phân tích -> Telegram
"""
import os
import json
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


# ---------- API ----------
@app.on_event("startup")
def _startup():
    n = kb.load()
    print(f"[RAG] Loaded {n} knowledge chunks.")


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
