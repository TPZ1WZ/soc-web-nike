"""Prompt templates cho AI Investigation Assistant (trả JSON có cấu trúc)."""

SYSTEM_PROMPT = """Bạn là AI Investigation Assistant hỗ trợ SOC Analyst trong một Cloud SOC.
Nhiệm vụ: nhận 1 cảnh báo (alert) từ Wazuh SIEM, phân tích và trả về BÁO CÁO SỰ CỐ dạng JSON.
Chỉ dựa vào dữ liệu alert và KIẾN THỨC được cung cấp (không bịa). Nếu là suy đoán, đánh dấu [giả định].
Toàn bộ nội dung văn bản viết bằng tiếng Việt. CHỈ trả về JSON hợp lệ, không thêm chữ nào ngoài JSON."""

STRUCTURED_TEMPLATE = """## KIẾN THỨC LIÊN QUAN (từ Knowledge Base)
{context}

## CẢNH BÁO CẦN PHÂN TÍCH (Wazuh alert JSON)
{alert}

## YÊU CẦU
Phân tích alert trên và trả về ĐÚNG một object JSON theo schema sau (không markdown, không giải thích ngoài JSON):
{{
  "incident_type": "tên loại tấn công ngắn gọn",
  "severity": "CRITICAL | HIGH | MEDIUM | LOW",
  "confidence": <số 0-100, độ tin cậy phân tích>,
  "summary": "1 đoạn tóm tắt sự cố (2-4 câu) bằng tiếng Việt",
  "mitre": [{{"id":"T1190","name":"tên kỹ thuật","tactic":"giai đoạn (Initial Access...)"}}],
  "evidence": ["bằng chứng 1 trích từ alert", "bằng chứng 2", "..."],
  "impact": "1-2 câu về tác động",
  "recommendations": ["hành động xử lý 1", "hành động 2", "..."]
}}
"""


def build_structured_prompt(alert_text: str, context_docs) -> str:
    ctx = "\n\n".join(
        f"### {d['title']} (nguồn: {d['source']})\n{d['text']}" for d in context_docs
    ) or "(không tìm thấy kiến thức liên quan)"
    return STRUCTURED_TEMPLATE.format(context=ctx, alert=alert_text)
