# Multi-Stage Web Attack (Chiến dịch tấn công đa giai đoạn)

## Nhận biết (Detection)
- Wazuh rule **100200** (level 15, group `attack_campaign`): >=6 alert nhóm `web_attack`
  từ **CÙNG một IP nguồn** trong 180 giây → dấu hiệu một chiến dịch có chủ đích (không phải quét ngẫu nhiên).
- Chuỗi alert điển hình từ cùng srcip theo thứ tự: recon (404 nhiều) → `SQLI_*` → `LOGIN_FAILED`
  nhiều → `SQLI_LOGIN_BYPASS`/`BROKEN_ACCESS` → `FILE_UPLOAD_SUSPICIOUS` → `XSS_STORED`.

## Ý nghĩa (Kill chain)
Attacker đi theo các bước (MITRE ATT&CK):
1. **Recon** (T1595) — dò endpoint, quét thư mục.
2. **Initial Access** (T1190) — SQL Injection.
3. **Credential Access** (T1110/T1552) — brute force + rút password_hash + bypass đăng nhập.
4. **Privilege Escalation** (T1078) — broken access, vào chức năng admin.
5. **Execution/Persistence** (T1505.003/T1083) — upload webshell + path traversal.
6. **Impact** (T1059.007) — Stored XSS đánh cắp phiên nạn nhân.

## Mức độ (Severity)
- **CRITICAL** — đây là tấn công có mục tiêu, nhiều giai đoạn, khả năng cao đã hoặc sắp chiếm được hệ thống.

## Xử lý (Response)
1. **Chặn ngay IP nguồn** ở tất cả các lớp (WAF, Security Group, firewall).
2. **Cô lập** WEB-SERVER, chụp trạng thái (memory/disk) để điều tra.
3. Truy vết mức độ xâm nhập: đã bypass login chưa (`SQLI_LOGIN_SUCCESS`)? Webshell đã bị gọi chưa? Dữ liệu nào bị rút?
4. **Xóa webshell/XSS payload**, buộc đổi toàn bộ mật khẩu, thu hồi token/session.
5. Vá tất cả lỗ hổng bị khai thác (prepared statement, phân quyền, validate upload, escape output).
6. Rà soát log tìm dấu hiệu duy trì truy cập (persistence) và di chuyển ngang.

## Correlation note cho AI
Khi thấy rule 100200 hoặc nhiều event khác loại cùng 1 srcip: KHÔNG phân tích rời rạc — hãy tổng hợp
thành **1 báo cáo chiến dịch (campaign report)**: liệt kê các giai đoạn theo thứ tự thời gian, đánh giá
attacker đã đạt tới bước nào, và mức thiệt hại.
