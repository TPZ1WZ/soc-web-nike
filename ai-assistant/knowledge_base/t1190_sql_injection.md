# SQL Injection — MITRE ATT&CK T1190 (Exploit Public-Facing Application)

## Nhận biết (Detection)
- Wazuh event: `SQLI_ATTEMPT`, `SQLI_ERROR`, `SQLI_QUERY` (rule 100110), `SQLI_LOGIN_BYPASS`/`SQLI_LOGIN_SUCCESS` (rule 100111).
- Dấu hiệu trong request: dấu nháy đơn `'`, từ khóa `UNION SELECT`, `OR 1=1`, `--`, `information_schema`, lỗi `bad SQL grammar` / `syntax error`.
- Ví dụ URL: `/api/v1/products/1'`, `/api/v1/products/0 UNION SELECT ... FROM users--`.

## Tác động (Impact)
- Đọc trộm dữ liệu (email, password_hash), bypass đăng nhập, sửa/xóa dữ liệu, đôi khi RCE.
- Mức độ: **CAO/NGHIÊM TRỌNG** (Critical) — đặc biệt khi kèm `SQLI_LOGIN_SUCCESS` (đã bypass được).

## Xử lý (Response / Remediation)
1. **Chặn IP nguồn** tấn công tại WAF/Security Group ngay lập tức.
2. Kiểm tra log DB (PostgreSQL) xem attacker đã truy vấn/rút được dữ liệu gì.
3. **Sửa code**: dùng **prepared statement / parameterized query**, KHÔNG nối chuỗi input vào SQL.
4. Validate & ép kiểu tham số (id phải là số).
5. Nếu nghi lộ password_hash → **buộc đổi mật khẩu** toàn bộ user, bật MFA.
6. Rà soát các endpoint tương tự, thêm WAF rule chặn pattern SQLi.

## MITRE
- Tactic: Initial Access. Technique: **T1190 Exploit Public-Facing Application**.
- Nếu bypass login: kèm **T1078 Valid Accounts**.
