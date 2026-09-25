# Broken Access Control / Privilege Escalation — MITRE ATT&CK T1078 (Valid Accounts)

## Nhận biết (Detection)
- Wazuh event: `BROKEN_ACCESS` (rule 100130), `ADMIN_ACTION` bởi user không phải admin.
- Dấu hiệu: user thường / ẩn danh gọi được endpoint admin (`/api/admin/users`, `DELETE /api/admin/users/{id}`) mà không bị chặn (401/403).
- Nguyên nhân gốc: thiếu kiểm tra quyền (`@PreAuthorize` không hiệu lực), cấu hình `permitAll`.

## Tác động (Impact)
- Xem/sửa/xóa dữ liệu của người khác (IDOR), leo thang đặc quyền, truy cập chức năng quản trị. Mức độ: **CAO**.

## Xử lý (Response / Remediation)
1. **Bật kiểm tra phân quyền** phía server: `@EnableMethodSecurity`, `hasRole('ADMIN')` cho endpoint admin.
2. Sửa SecurityConfig: KHÔNG dùng `anyRequest().permitAll()`; whitelist đúng endpoint public, còn lại `authenticated()`.
3. Kiểm tra **IDOR**: mọi truy vấn theo id phải xác thực chủ sở hữu.
4. Ghi log + cảnh báo khi có truy cập chức năng admin bởi non-admin.
5. Review toàn bộ ma trận phân quyền (RBAC).

## MITRE
- Tactic: Privilege Escalation / Defense Evasion. Technique: **T1078 Valid Accounts**; liên quan **T1068** (Exploitation for Privilege Escalation).
