# Incident Response Playbook (SOC) & Thông tin hệ thống Lab

## Quy trình xử lý sự cố 6 bước (NIST)
1. **Preparation**: có sẵn log, rule, cảnh báo (Wazuh).
2. **Identification**: xác định loại tấn công từ alert (event, rule.id, MITRE).
3. **Containment**: chặn IP nguồn, cô lập máy bị ảnh hưởng, tạm khóa tài khoản.
4. **Eradication**: xóa mã độc (webshell/XSS payload), vá lỗ hổng (sửa code).
5. **Recovery**: khôi phục dịch vụ, đổi mật khẩu, xác minh sạch.
6. **Lessons Learned**: cập nhật rule, hardening, viết báo cáo.

## Cách chấm mức độ nghiêm trọng (Severity)
- **CRITICAL**: tấn công thành công (SQLI_LOGIN_SUCCESS, webshell chạy được, RCE, path traversal ghi file hệ thống).
- **HIGH**: tấn công có khả năng thành công (SQLi rút data, brute force >5 fail, broken access vào admin).
- **MEDIUM**: dò quét, thử payload đơn lẻ, login fail rải rác.
- **LOW**: request bất thường không rõ ý đồ.

## Thông tin hệ thống Lab (để AI hiểu ngữ cảnh)
- Web mục tiêu: **NiceStore** (Spring Boot + PostgreSQL), agent Wazuh tên **WEB-SERVER**.
- Các event bảo mật do web sinh ra (logger "SECURITY", ghi vào security.log):
  `SQLI_ATTEMPT, SQLI_ERROR, SQLI_LOGIN_BYPASS, SQLI_LOGIN_SUCCESS,
   LOGIN_FAILED, LOGIN_SUCCESS, BROKEN_ACCESS, ADMIN_ACTION,
   FILE_UPLOAD_SUSPICIOUS, XSS_STORED`.
- Custom rule Wazuh: 100110 (SQLi), 100111 (SQLi bypass), 100120/100121 (brute force),
  100130 (broken access), 100140 (webshell), 100141 (path traversal), 100150 (XSS).
- SOC-SERVER chạy Wazuh (Docker single-node). Tấn công đến từ Kali/máy ngoài.

## Định dạng báo cáo sự cố mong muốn
Incident Type, Severity, MITRE ATT&CK (ID + tên), Affected Asset, Source IP,
Evidence (bằng chứng từ alert), Impact, Recommended Actions (các bước xử lý cụ thể).
