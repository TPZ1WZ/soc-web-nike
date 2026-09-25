# File Upload Webshell & Path Traversal — MITRE T1505.003 / T1083

## Nhận biết (Detection)
- Wazuh event: `FILE_UPLOAD_SUSPICIOUS` (rule 100140) — tên file đuôi nguy hiểm (`.php .jsp .jspx .asp .sh .exe .war`).
- `PATH_TRAVERSAL`/rule 100141 — tên file chứa `../` hoặc `..\` để ghi ra ngoài thư mục upload.
- Endpoint: `/reviews/add/{id}` (field images), `/api/v1/vuln/upload`.

## Tác động (Impact)
- **Webshell**: nếu server chạy được file (PHP/JSP) → **RCE** (chạy lệnh, chiếm server). Mức độ: **NGHIÊM TRỌNG**.
- **Path Traversal**: ghi/đè file tùy ý (config, code) → có thể dẫn tới RCE hoặc phá hoại.

## Xử lý (Response / Remediation)
1. **Xóa ngay file độc** đã upload (kiểm tra thư mục `uploads/`).
2. Chặn IP nguồn.
3. **Whitelist định dạng** (chỉ jpg/png), kiểm tra MIME + magic bytes, giới hạn kích thước.
4. **Đổi tên file ngẫu nhiên**, KHÔNG dùng tên gốc; làm sạch `../`, chuẩn hóa đường dẫn.
5. Lưu file ở thư mục **không cho thực thi** (no-exec), tách khỏi web root.
6. Quét malware file upload; rà soát xem webshell đã bị gọi/chạy chưa.

## MITRE
- **T1505.003 Server Software Component: Web Shell** (webshell).
- **T1083 File and Directory Discovery** / Arbitrary File Write (path traversal).
