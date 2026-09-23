package com.proj.webprojrct.vuln;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * ============================================================================
 * ⚠️⚠️  KỊCH BẢN LAB SOC #1b - SQL INJECTION AUTHENTICATION BYPASS  ⚠️⚠️
 * ----------------------------------------------------------------------------
 * Trang đăng nhập CỐ TÌNH nối chuỗi SQL (KHÔNG dùng Spring Security, KHÔNG
 * tham số hóa) -> có thể ĐĂNG NHẬP KHÔNG CẦN MẬT KHẨU.
 *
 * GET  /vuln-login              -> form đăng nhập (HTML)
 * POST /api/v1/vuln/login-sqli  -> xử lý, nối thẳng username/password vào SQL
 *
 * Payload bypass (gõ vào ô Email/Username):
 *   admin@example.com' --            (đăng nhập thẳng thành admin, bỏ qua mật khẩu)
 *   ' OR '1'='1' LIMIT 1 --          (đăng nhập bằng user đầu tiên trong bảng)
 *   ' OR role='ADMIN' LIMIT 1 --     (đăng nhập bằng 1 tài khoản admin bất kỳ)
 *
 * KHÔNG dùng kiểu code này ở production.
 * ============================================================================
 */
@RestController
public class VulnLoginController {

    private final JdbcTemplate jdbc;
    private final SecurityAudit audit;

    public VulnLoginController(JdbcTemplate jdbc, SecurityAudit audit) {
        this.jdbc = jdbc;
        this.audit = audit;
    }

    /** Trang đăng nhập lab (HTML thuần, không cần template engine). */
    @GetMapping(value = "/vuln-login", produces = MediaType.TEXT_HTML_VALUE)
    public String loginPage(@RequestParam(required = false) String msg) {
        String banner = (msg == null) ? "" :
                "<div class='box " + (msg.startsWith("OK") ? "ok" : "err") + "'>" + escape(msg) + "</div>";
        return ("""
            <!doctype html><html lang='vi'><head><meta charset='utf-8'>
            <title>Vuln Login - LAB SOC</title>
            <style>
              body{font-family:system-ui,Arial;background:#0f172a;color:#e2e8f0;display:flex;
                   min-height:100vh;align-items:center;justify-content:center;margin:0}
              .card{background:#1e293b;padding:28px 32px;border-radius:12px;width:360px;
                    box-shadow:0 10px 30px rgba(0,0,0,.4)}
              h2{margin:0 0 4px}.sub{color:#94a3b8;font-size:13px;margin-bottom:18px}
              label{display:block;font-size:13px;margin:12px 0 4px}
              input{width:100%;padding:10px;border-radius:8px;border:1px solid #334155;
                    background:#0f172a;color:#e2e8f0;box-sizing:border-box}
              button{margin-top:18px;width:100%;padding:11px;border:0;border-radius:8px;
                     background:#ef4444;color:#fff;font-weight:700;cursor:pointer}
              .box{padding:10px;border-radius:8px;margin-bottom:14px;font-size:14px}
              .ok{background:#064e3b;color:#6ee7b7}.err{background:#7f1d1d;color:#fecaca}
              .hint{margin-top:16px;font-size:12px;color:#64748b;line-height:1.6}
              code{background:#0f172a;padding:2px 5px;border-radius:4px;color:#fbbf24}
            </style></head><body>
            <form class='card' method='post' action='/api/v1/vuln/login-sqli'>
              <h2>⚠️ Vuln Login</h2><div class='sub'>Trang đăng nhập CỐ TÌNH dính SQLi (LAB SOC)</div>
              __BANNER__
              <label>Email / Username</label>
              <input name='username' placeholder='email hoặc payload' autofocus>
              <label>Mật khẩu</label>
              <input name='password' type='text' placeholder='mật khẩu'>
              <button type='submit'>ĐĂNG NHẬP</button>
              <div class='hint'>Thử bypass:<br>
                <code>admin@example.com' --</code><br>
                <code>' OR role='ADMIN' LIMIT 1 --</code></div>
            </form></body></html>
            """).replace("__BANNER__", banner);
    }

    /** Xử lý đăng nhập — CỐ TÌNH nối chuỗi SQL. */
    @PostMapping(value = "/api/v1/vuln/login-sqli", produces = MediaType.TEXT_HTML_VALUE)
    public String doLogin(@RequestParam String username,
                          @RequestParam String password,
                          HttpServletRequest req) {
        // ❌ LỖ HỔNG: nối thẳng input vào câu SQL xác thực
        String sql = "SELECT id, email, role FROM users WHERE email = '"
                + username + "' AND password_hash = '" + password + "'";

        // Phát hiện dấu hiệu injection để đánh dấu log (vẫn thực thi -> đúng bản chất lỗ hổng)
        boolean looksInjected = username.contains("'") || password.contains("'");
        audit.log(looksInjected ? "SQLI_LOGIN_BYPASS" : "LOGIN_ATTEMPT", req,
                "username=\"" + username + "\" sql=\"" + sql + "\"");

        try {
            List<Map<String, Object>> rows = jdbc.queryForList(sql);
            if (!rows.isEmpty()) {
                Map<String, Object> u = rows.get(0);
                if (looksInjected) {
                    audit.log("SQLI_LOGIN_SUCCESS", req,
                            "bypassed_as_email=\"" + u.get("email") + "\" role=" + u.get("role"));
                }
                return redirect("OK - Đăng nhập thành công! Vào bằng: "
                        + u.get("email") + " (role=" + u.get("role") + ")"
                        + (looksInjected ? "  [BYPASS QUA SQL INJECTION]" : ""));
            }
            return redirect("Sai tài khoản hoặc mật khẩu");
        } catch (Exception ex) {
            audit.logError("SQLI_ERROR", req, "username=\"" + username + "\" sql=\"" + sql + "\"", ex);
            return redirect("Lỗi truy vấn: " + ex.getMessage());
        }
    }

    private String redirect(String msg) {
        // Trả về trang login kèm thông báo (giữ demo đơn giản, không session)
        return loginPage(msg);
    }

    private String escape(String s) {
        return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
