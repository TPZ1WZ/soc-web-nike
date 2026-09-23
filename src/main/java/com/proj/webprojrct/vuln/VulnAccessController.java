package com.proj.webprojrct.vuln;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * ============================================================================
 * ⚠️  KỊCH BẢN LAB SOC #3 - BROKEN ACCESS CONTROL (THIẾU KIỂM TRA QUYỀN)  ⚠️
 * ----------------------------------------------------------------------------
 * "Chức năng admin" nhưng KHÔNG kiểm tra role -> user thường / khách vẫn gọi được.
 * (App gốc còn để authorizeHttpRequests().anyRequest().permitAll() nên toàn bộ
 *  /admin/** cũng đang mở — đây là bản thu nhỏ có ghi log để demo cho Wazuh.)
 *
 * Log sinh ra (logs/security.log):
 *   event=ADMIN_ACTION action=delete_user target=5 actor=customer01 role=[ROLE_USER]
 *   event=BROKEN_ACCESS action=delete_user actor=customer01 role=[ROLE_USER]  (khi không phải admin)
 *
 * Cách khai thác thử (Kali) - gọi bằng tài khoản thường hoặc không token:
 *   curl -X POST "http://<host>:8080/api/v1/vuln/admin/delete-user?id=5"
 * ============================================================================
 */
@RestController
@RequestMapping("/api/v1/vuln/admin")
public class VulnAccessController {

    private final SecurityAudit audit;

    public VulnAccessController(SecurityAudit audit) {
        this.audit = audit;
    }

    @PostMapping("/delete-user")
    public Object deleteUser(@RequestParam Long id, HttpServletRequest req) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String actor = (auth != null) ? auth.getName() : "anonymous";
        String roles = (auth != null && auth.getAuthorities() != null)
                ? auth.getAuthorities().toString() : "[]";

        boolean isAdmin = roles.contains("ADMIN");

        // ❌ LỖ HỔNG: KHÔNG chặn khi không phải admin — chỉ ghi log rồi vẫn "thực hiện"
        if (!isAdmin) {
            audit.log("BROKEN_ACCESS", req,
                    "action=delete_user target=" + id + " actor=\"" + actor + "\" role=" + roles);
        }

        audit.log("ADMIN_ACTION", req,
                "action=delete_user target=" + id + " actor=\"" + actor + "\" role=" + roles);

        // Trong lab không xóa thật, chỉ mô phỏng để sinh log
        return Map.of("success", true, "message", "User " + id + " deleted (simulated)",
                "actor", actor, "role", roles, "wasAdmin", isAdmin);
    }
}
