# Stored XSS — MITRE ATT&CK T1059.007 (JavaScript)

## Nhận biết (Detection)
- Wazuh event: `XSS_STORED` (rule 100150) — payload chứa `<script`, `onerror=`, `onload=`, `<img`, `<svg`, `javascript:`.
- Endpoint: `/reviews/add/{id}` (nội dung đánh giá render bằng `th:utext` không escape).

## Tác động (Impact)
- Mã JS của attacker chạy trong trình duyệt **mọi nạn nhân** xem trang → đánh cắp dữ liệu qua session nạn nhân, giả form đăng nhập (phishing) lấy mật khẩu, thao tác thay nạn nhân, redirect. Mức độ: **CAO**.
- Cookie HttpOnly giúp giảm trộm token, nhưng KHÔNG chặn được XSS thực thi.

## Xử lý (Response / Remediation)
1. **Xóa bản ghi chứa payload** (review độc) khỏi DB.
2. **Escape output**: dùng `th:text` thay `th:utext`; encode HTML mọi dữ liệu người dùng.
3. Thêm **Content Security Policy (CSP)** chặn inline script.
4. Đặt cookie **HttpOnly + SameSite** (giảm thiệt hại).
5. Lọc/whitelist input (sanitize HTML) phía server.
6. Rà soát các chỗ render dữ liệu user khác.

## MITRE
- Tactic: Execution. Technique: **T1059.007 Command and Scripting Interpreter: JavaScript**.
