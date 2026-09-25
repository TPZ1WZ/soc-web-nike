# Brute Force / Credential Attack — MITRE ATT&CK T1110

## Nhận biết (Detection)
- Wazuh event: nhiều `LOGIN_FAILED` (rule 100120) cùng một `srcip` trong thời gian ngắn → kích rule tương quan **100121** (level 12) "BRUTE FORCE".
- Dấu hiệu: >5 lần đăng nhập thất bại/phút cùng IP; nhiều username khác nhau (credential stuffing).
- Endpoint: `/api/v1/auth/login`.

## Tác động (Impact)
- Đoán được mật khẩu → chiếm tài khoản (nhất là admin). Mức độ: **CAO** nếu thành công (`LOGIN_SUCCESS` ngay sau chuỗi `LOGIN_FAILED`).

## Xử lý (Response / Remediation)
1. **Chặn/khóa IP nguồn** (rate-limit, fail2ban, WAF).
2. **Khóa tạm tài khoản** bị nhắm sau N lần sai; buộc đổi mật khẩu nếu nghi bị lộ.
3. Bật **MFA (đa yếu tố)** cho tài khoản admin.
4. Thêm **rate limiting + CAPTCHA** ở trang login.
5. Rà soát xem có `LOGIN_SUCCESS` từ IP tấn công không (đã vào được chưa).
6. Dùng chính sách mật khẩu mạnh, khóa account lockout.

## MITRE
- Tactic: Credential Access. Technique: **T1110 Brute Force** (T1110.001 Password Guessing, T1110.004 Credential Stuffing).
