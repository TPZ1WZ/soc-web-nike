package com.proj.webprojrct.vuln;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * ============================================================================
 * ⚠️⚠️  KỊCH BẢN LAB SOC #1 - SQL INJECTION (CỐ TÌNH DÍNH LỖI)  ⚠️⚠️
 * ----------------------------------------------------------------------------
 * KHÔNG BAO GIỜ dùng kiểu code này ở production. Ở đây nối thẳng input người
 * dùng vào câu SQL (native query) để tạo lỗ hổng SQL Injection có thể khai thác,
 * phục vụ thu thập:
 *   - Web log        : GET /api/v1/vuln/product?id=' OR 1=1--
 *   - Java app log   : SQLException / BadSqlGrammarException  (logs/app.log, security.log)
 *   - PostgreSQL log : ERROR: syntax error at or near "'"
 *
 * Cách khai thác thử (từ Kali):
 *   curl "http://<host>:8080/api/v1/vuln/product?id=10"
 *   curl "http://<host>:8080/api/v1/vuln/product?id=0 OR 1=1--"      (dump toàn bộ)
 *   curl "http://<host>:8080/api/v1/vuln/product?id='"               (gây syntax error)
 *   curl "http://<host>:8080/api/v1/vuln/search?name=x' OR '1'='1"   (bypass filter)
 *   curl "http://<host>:8080/api/v1/vuln/product?id=1 UNION SELECT email,password_hash,3,4,5,6,7,8,9,10 FROM users--"
 * ============================================================================
 */
@RestController
@RequestMapping("/api/v1/vuln")
public class VulnSqlController {

    private final JdbcTemplate jdbc;
    private final SecurityAudit audit;

    public VulnSqlController(JdbcTemplate jdbc, SecurityAudit audit) {
        this.jdbc = jdbc;
        this.audit = audit;
    }

    /**
     * Tìm sản phẩm theo id — CỐ TÌNH nối chuỗi -> SQL Injection.
     */
    @GetMapping("/product")
    public Object productById(@RequestParam String id, HttpServletRequest req) {
        // ❌ LỖ HỔNG: nối thẳng input vào câu lệnh SQL
        String sql = "SELECT * FROM product WHERE id = " + id;
        audit.log("SQLI_QUERY", req, "param=id value=\"" + id + "\" sql=\"" + sql + "\"");

        try {
            List<Map<String, Object>> rows = jdbc.queryForList(sql);
            return Map.of("success", true, "sql", sql, "count", rows.size(), "rows", rows);
        } catch (Exception ex) {
            // Ghi cả stacktrace -> sinh Java log; PostgreSQL cũng ghi ERROR ở phía DB
            audit.logError("SQLI_ERROR", req, "param=id value=\"" + id + "\" sql=\"" + sql + "\"", ex);
            return Map.of("success", false, "sql", sql, "error", ex.getMessage());
        }
    }

    /**
     * Tìm sản phẩm theo tên — CỐ TÌNH nối chuỗi trong LIKE -> SQL Injection dạng chuỗi.
     */
    @GetMapping("/search")
    public Object searchByName(@RequestParam String name, HttpServletRequest req) {
        // ❌ LỖ HỔNG: nối thẳng input (kể cả dấu nháy) vào SQL
        String sql = "SELECT id, name, price FROM product WHERE name LIKE '%" + name + "%'";
        audit.log("SQLI_QUERY", req, "param=name value=\"" + name + "\" sql=\"" + sql + "\"");

        try {
            List<Map<String, Object>> rows = jdbc.queryForList(sql);
            return Map.of("success", true, "sql", sql, "count", rows.size(), "rows", rows);
        } catch (Exception ex) {
            audit.logError("SQLI_ERROR", req, "param=name value=\"" + name + "\" sql=\"" + sql + "\"", ex);
            return Map.of("success", false, "sql", sql, "error", ex.getMessage());
        }
    }
}
