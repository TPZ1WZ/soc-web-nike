package com.proj.webprojrct.vuln;

import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

/**
 * ============================================================================
 * ⚠️  KỊCH BẢN LAB SOC #2 - BRUTE FORCE LOGIN (KHÔNG CHỐNG DÒ MẬT KHẨU)  ⚠️
 * ----------------------------------------------------------------------------
 * Endpoint đăng nhập KHÔNG có rate-limit / khóa tài khoản / captcha, và ghi log
 * chi tiết mỗi lần thử để Wazuh phát hiện "nhiều lần đăng nhập thất bại".
 *
 * Log sinh ra (logs/security.log):
 *   event=LOGIN_FAILED  username=admin ip=1.2.3.4 reason=bad_password
 *   event=LOGIN_SUCCESS username=admin ip=1.2.3.4
 *
 * Cách khai thác thử (Hydra / vòng lặp bash từ Kali):
 *   for p in 123456 password admin admin123 nike2024; do
 *     curl -s -X POST http://<host>:8080/api/v1/vuln/login \
 *          -H "Content-Type: application/json" \
 *          -d "{\"username\":\"admin@nike.com\",\"password\":\"$p\"}";
 *   done
 * ============================================================================
 */
@RestController
@RequestMapping("/api/v1/vuln")
public class VulnAuthController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final SecurityAudit audit;

    public VulnAuthController(UserRepository userRepository,
                             PasswordEncoder passwordEncoder,
                             SecurityAudit audit) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.audit = audit;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body, HttpServletRequest req) {
        String username = body.getOrDefault("username", "");
        String password = body.getOrDefault("password", "");

        // ❌ Không đếm số lần thất bại, không khóa tài khoản, không delay -> brute force thoải mái
        Optional<User> opt = userRepository.findByEmail(username);

        if (opt.isEmpty()) {
            audit.log("LOGIN_FAILED", req, "username=\"" + username + "\" reason=user_not_found");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "Invalid username or password"));
        }

        User user = opt.get();
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            audit.log("LOGIN_FAILED", req, "username=\"" + username + "\" reason=bad_password");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "Invalid username or password"));
        }

        audit.log("LOGIN_SUCCESS", req, "username=\"" + username + "\" role=" + user.getRole());
        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Login OK",
                "user", Map.of("email", user.getEmail(), "role", user.getRole())
        ));
    }
}
