# AI Investigation Assistant — Cloud SOC (Chương 3)

Service nhận **alert từ Wazuh** → **RAG** tra Knowledge Base → **LLM (OpenAI)** phân tích →
sinh **báo cáo sự cố** (Incident Report) + giao diện demo + (tùy chọn) gửi Telegram.

```
Wazuh SIEM ──alert JSON──► AI-SERVER (FastAPI)
                            ├─ RAG: knowledge_base/*.md → Chroma (embedding)
                            ├─ LLM: OpenAI (gpt-4o-mini)
                            └─ Web UI  (http://localhost:8000)
```

## Cấu trúc
```
ai-assistant/
├── app.py              # FastAPI: /api/analyze, /api/alerts, /api/ingest, UI
├── rag.py              # nạp KB -> Chroma -> retrieve
├── llm.py              # gọi OpenAI (đổi provider qua .env)
├── prompts.py          # prompt phân tích
├── static/index.html   # giao diện demo
├── knowledge_base/*.md # MITRE + IR playbook (RAG đọc)
├── wazuh-integration/  # script đẩy alert tự động (tùy chọn)
├── requirements.txt · Dockerfile · docker-compose.yml · .env.example
```

## Chạy nhanh (local hoặc EC2)
```bash
cd ai-assistant
cp .env.example .env
# sửa .env: điền OPENAI_API_KEY, và WAZUH_INDEXER_URL/USER/PASS (SOC của bạn)

# Cách A - Docker (khuyên):
docker compose up -d --build
# Cách B - Python:
pip install -r requirements.txt && uvicorn app:app --host 0.0.0.0 --port 8000
```
Mở trình duyệt: **http://localhost:8000**

## Dùng thử
1. Bấm **"Dùng alert mẫu"** → **Phân tích** → xem báo cáo sự cố AI sinh ra.
2. Bấm **"Lấy alert từ Wazuh"** → kéo alert web_attack thật từ Indexer → chọn 1 alert → **Phân tích**.
3. (Tùy chọn) tích hợp tự động: xem `wazuh-integration/custom-ai.py` để Wazuh tự đẩy alert sang AI + gửi Telegram.

## API
| Endpoint | Việc |
|----------|------|
| `POST /api/analyze` | body `{"alert": <json/text>}` → `{report, context}` |
| `GET /api/alerts?limit=15` | kéo alert web_attack mới nhất từ Wazuh Indexer |
| `POST /api/ingest` | webhook cho Wazuh integrator (tự phân tích + Telegram) |

## Đổi LLM
- OpenAI (mặc định): `OPENAI_API_KEY`, `OPENAI_MODEL=gpt-4o-mini`.
- Ollama (local, free): `OPENAI_BASE_URL=http://localhost:11434/v1`, `OPENAI_MODEL=llama3.1`.

## Khớp Chương 3 của đồ án
- 3.3 Knowledge Base → `knowledge_base/*.md`
- 3.4 RAG Pipeline → `rag.py` (embedding + Chroma vector DB + retrieval)
- 3.5 LLM Integration → `llm.py` + `prompts.py` (prompt engineering + context injection)
- 3.6 Giao diện → `static/index.html`
- 3.7 Đánh giá → test với alert SQLi / Brute Force / Broken Access (nút "Lấy alert từ Wazuh")
