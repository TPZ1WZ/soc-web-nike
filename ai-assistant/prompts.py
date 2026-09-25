"""Prompt templates cho AI Investigation Assistant."""

SYSTEM_PROMPT = """Bạn là AI Investigation Assistant hỗ trợ SOC Analyst trong một Cloud SOC.
Nhiệm vụ: nhận 1 cảnh báo (alert) từ Wazuh SIEM, phân tích và viết BÁO CÁO SỰ CỐ ngắn gọn, chính xác.
Chỉ dựa vào dữ liệu alert và KIẾN THỨC được cung cấp (không bịa). Nếu thiếu thông tin, nói rõ.
Trả lời bằng tiếng Việt, đúng định dạng được yêu cầu."""

ANALYSIS_TEMPLATE = """## KIẾN THỨC LIÊN QUAN (từ Knowledge Base)
{context}

## CẢNH BÁO CẦN PHÂN TÍCH (Wazuh alert JSON)
{alert}

## YÊU CẦU
Viết báo cáo sự cố theo đúng các mục sau (Markdown), ngắn gọn, dựa trên alert + kiến thức trên:

**1. Loại tấn công (Incident Type):**
**2. Mức độ (Severity):** (CRITICAL / HIGH / MEDIUM / LOW) — giải thích ngắn
**3. MITRE ATT&CK:** (mã + tên kỹ thuật)
**4. Tài sản bị ảnh hưởng (Affected Asset):**
**5. IP nguồn (Source IP):**
**6. Bằng chứng (Evidence):** (trích từ alert: event, url, payload...)
**7. Tác động (Impact):**
**8. Khuyến nghị xử lý (Recommended Actions):** (liệt kê các bước cụ thể)
"""


def build_analysis_prompt(alert_text: str, context_docs) -> str:
    ctx = "\n\n".join(
        f"### {d['title']} (nguồn: {d['source']})\n{d['text']}" for d in context_docs
    ) or "(không tìm thấy kiến thức liên quan)"
    return ANALYSIS_TEMPLATE.format(context=ctx, alert=alert_text)
