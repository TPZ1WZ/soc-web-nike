package com.proj.webprojrct.auth;

import com.proj.webprojrct.auth.dto.request.ChangePasswordRequest;
import com.proj.webprojrct.auth.dto.request.LoginDTO;
import com.proj.webprojrct.auth.dto.request.RefreshTokenRequest;
import com.proj.webprojrct.auth.dto.request.RegisterDTO;
import com.proj.webprojrct.auth.dto.request.ResetPasswordRequest;
import com.proj.webprojrct.auth.dto.response.LoginResponseV1;
import com.proj.webprojrct.auth.dto.response.LoginResponseV2;
import com.proj.webprojrct.auth.dto.response.RegisterResponse;
import com.proj.webprojrct.common.error.Common;
import com.proj.webprojrct.common.config.ApiMessage;
import com.proj.webprojrct.common.exception.VerificationException;
import com.proj.webprojrct.common.service.TokenCleanUpService;
import com.proj.webprojrct.common.util.CookieUtil;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.user.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import jakarta.persistence.EntityExistsException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Authentication Controller với logging chi tiết cho debugging
 * Xử lý Login, Register, Token Refresh, Password Reset, Email Verification
 */
@RestController
@RequestMapping("/api/v1/auth")
@Slf4j
public class AuthenticationController {

    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final AuthenicationService authenicationService;
    private final UserService userService;
    private final UserRepository userRepository;
    private final CookieUtil cookieUtil;

    @Autowired
    private JwtService jwtService;
    @Autowired
    private TokenCleanUpService tokenCleanUpService;

    public AuthenticationController(UserService userService, AuthenicationService authenicationService,
                                    AuthenticationManagerBuilder authenticationManagerBuilder,
                                    UserRepository userRepository, CookieUtil cookieUtil) {
        this.authenticationManagerBuilder = authenticationManagerBuilder;
        this.authenicationService = authenicationService;
        this.userService = userService;
        this.userRepository = userRepository;
        this.cookieUtil = cookieUtil;
    }

    @GetMapping("info")
    public Object info(@AuthenticationPrincipal User user) {
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("authenticated", false, "message", "User not logged in"));
        }
        Map<String, Object> result = new HashMap<>();
        result.put("authenticated", true);
        result.put("email", user.getEmail());
        result.put("name", user.getFullName());
        return ResponseEntity.ok(result);
    }

    @PostMapping("/register")
    @ApiMessage("Register new user")
    public ResponseEntity<RegisterResponse> register(@RequestBody RegisterDTO registerDTO, HttpServletRequest request) {
        String clientIp = request.getRemoteAddr();
        log.info("📝 [REGISTER] Registration request - Email: {} | IP: {} | Time: {}",
                registerDTO.getEmail(), clientIp, LocalDateTime.now());

        try {
            log.debug("Validating registration data - Email: {} | HasPassword: {}",
                    registerDTO.getEmail(), registerDTO.getPassword() != null);

            authenicationService.handleRegister(registerDTO);

            log.info("✅ [REGISTER] User registered successfully - Email: {} | Verification email sent",
                    registerDTO.getEmail());

            RegisterResponse response = RegisterResponse.builder()
                    .success(true)
                    .message("User registered successfully. Please check your email to verify your account.")
                    .email(registerDTO.getEmail())
                    .build();
            return ResponseEntity.status(HttpStatus.CREATED).body(response);

        } catch (EntityExistsException e) {
            log.warn("⚠️ [REGISTER] Registration failed - Email already exists: {} | IP: {}",
                    registerDTO.getEmail(), clientIp);

            RegisterResponse response = RegisterResponse.builder()
                    .success(false)
                    .message(e.getMessage())
                    .email(registerDTO.getEmail())
                    .build();
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);

        } catch (Exception e) {
            log.error("❌ [REGISTER] Registration failed - Email: {} | Error: {} | IP: {}",
                    registerDTO.getEmail(), e.getMessage(), clientIp, e);

            RegisterResponse response = RegisterResponse.builder()
                    .success(false)
                    .message("Registration failed: " + e.getMessage())
                    .build();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseV2> login(@RequestBody LoginDTO loginDto,
                                                 HttpServletRequest request,
                                                 HttpServletResponse response) {
        String clientIp = request.getRemoteAddr();
        try {
            // Xác thực username/password
            UsernamePasswordAuthenticationToken authToken
                    = new UsernamePasswordAuthenticationToken(loginDto.getUsername(), loginDto.getPassword());

            Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authToken);


            // Lưu thông tin xác thực vào context
            SecurityContextHolder.getContext().setAuthentication(authentication);

            // Lấy user từ DB để sinh JWT
            User user = userRepository.findByEmail(loginDto.getUsername())
                    .orElseThrow(() -> {
                        return new RuntimeException("User not found");
                    });

            // Generate tokens
            String accessToken = jwtService.generateAccessToken(user);
            String refreshToken = jwtService.generateRefreshToken(user);

            // 🍪 Set tokens as HTTP-only cookies (SECURE)
            cookieUtil.setAccessTokenCookie(response, accessToken);
            cookieUtil.setRefreshTokenCookie(response, refreshToken);

            // Lưu refresh_token vào DB
            user.setRefreshToken(refreshToken);
            userRepository.save(user);


            LoginResponseV2 loginResponse = LoginResponseV2.builder()
                    .success(true)
                    .role(user.getRole().name())
                    .message("Login successful")
                    .build();

            return ResponseEntity.ok().body(loginResponse);

        } catch (BadCredentialsException e) {
            log.warn("⚠️ [LOGIN] Bad credentials - Username: {} | IP: {} | Error: {}",
                    loginDto.getUsername(), clientIp, e.getMessage());
            throw e; // Spring Security sẽ xử lý

        } catch (AuthenticationException e) {
            log.error("❌ [LOGIN] Authentication failed - Username: {} | IP: {} | Error: {}",
                    loginDto.getUsername(), clientIp, e.getMessage());
            throw e;

        } catch (Exception e) {
            log.error("❌ [LOGIN] Unexpected error - Username: {} | IP: {} | Error: {}",
                    loginDto.getUsername(), clientIp, e.getMessage(), e);
            throw new RuntimeException("Login failed: " + e.getMessage(), e);
        }
    }

    @PostMapping("/refresh")
    @ApiMessage("Get Access Token")
    public ResponseEntity<LoginResponseV2> getNewAccessToken(HttpServletRequest request, HttpServletResponse response) throws EntityExistsException {
        log.info("🔄 [REFRESH] Refresh token request from cookies");

        try {
            // 🍪 Lấy refresh token từ cookies
            String refreshToken = cookieUtil.getRefreshTokenFromCookies(request)
                    .orElseThrow(() -> new RuntimeException("Refresh token not found in cookies"));

            // Tạo request object để tái sử dụng service hiện tại
            RefreshTokenRequest refreshRequest = new RefreshTokenRequest();
            refreshRequest.setRefresh_token(refreshToken);

            LoginResponseV1 tokenResponse = this.authenicationService.handleRefreshToken(refreshRequest);

            // 🍪 Set new tokens as cookies
            cookieUtil.setAccessTokenCookie(response, tokenResponse.getAccess_token());
            cookieUtil.setRefreshTokenCookie(response, tokenResponse.getRefresh_token());

            // Get user info for response
            String username = jwtService.extractUsername(tokenResponse.getAccess_token());
            User user = userRepository.findByEmail(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));


            LoginResponseV2 response2 = LoginResponseV2.builder()
                    .success(true)
                    .message("Token refreshed successfully")
                    .build();

            log.info("✅ [REFRESH] New access token generated and set as cookie");
            return ResponseEntity.ok().body(response2);
        } catch (Exception e) {
            log.error("❌ [REFRESH] Failed to refresh token - Error: {}", e.getMessage(), e);
            throw e;
        }
    }

    @PostMapping("/logout")
    @ApiMessage("Logout user")
    public ResponseEntity<Map<String, Object>> logout(HttpServletRequest request, HttpServletResponse response) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication != null ? authentication.getName() : "anonymous";

        log.info("🚪 [LOGOUT] Logout request - User: {}", username);

        try {
            // 🍪 Clear all authentication cookies
            cookieUtil.clearAuthCookies(response);

            // Clear security context
            SecurityContextHolder.clearContext();

            log.info("✅ [LOGOUT] Logout successful - User: {} | Cookies cleared", username);

            Map<String, Object> logoutResponse = Map.of(
                    "success", true,
                    "message", "Logout successful"
            );

            return ResponseEntity.ok().body(logoutResponse);
        } catch (Exception e) {
            log.error("❌ [LOGOUT] Logout failed - User: {} | Error: {}", username, e.getMessage(), e);

            Map<String, Object> errorResponse = Map.of(
                    "success", false,
                    "message", "Logout failed: " + e.getMessage()
            );

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @PostMapping("/forgot-password")
    @ApiMessage("Get Access Token")
    public ResponseEntity<Void> forgotPassword(@RequestParam String email) throws EntityExistsException {
        log.info("🔑 [FORGOT-PASSWORD] Password reset request - Email: {} | Time: {}", email, LocalDateTime.now());

        try {
            this.authenicationService.handleForgotPassword(email);
            log.info("✅ [FORGOT-PASSWORD] Reset email sent successfully - Email: {}", email);
            return ResponseEntity.status(HttpStatus.CREATED).body(null);
        } catch (Exception e) {
            log.error("❌ [FORGOT-PASSWORD] Failed to send reset email - Email: {} | Error: {}", email, e.getMessage(), e);
            throw e;
        }
    }

    @GetMapping("/verify/{token}")
    @ApiMessage("Verify Token")
    public ResponseEntity<Void> verifyToken(@PathVariable("token") String token) throws VerificationException {
        log.info("✉️ [VERIFY] Email verification request - Token: {}...", token.substring(0, Math.min(20, token.length())));

        try {
            this.authenicationService.handleVerify(token);
            log.info("✅ [VERIFY] Email verified successfully - Token: {}...", token.substring(0, 10));
            return ResponseEntity.ok().body(null);
        } catch (Exception e) {
            log.error("❌ [VERIFY] Email verification failed - Token: {}... | Error: {}",
                    token.substring(0, Math.min(20, token.length())), e.getMessage(), e);
            throw e;
        }
    }

    @PostMapping("/reset-password")
    @ApiMessage("Reset password")
    public ResponseEntity<String> resetPassword(@RequestBody ResetPasswordRequest resetPasswordRequest) throws VerificationException {
        log.info("🔐 [RESET-PASSWORD] Password reset request - Token provided");

        try {
            authenicationService.handleResetPassword(resetPasswordRequest);
            log.info("✅ [RESET-PASSWORD] Password reset successfully");
            return ResponseEntity.ok().body("Reset password successfully");
        } catch (Exception e) {
            log.error("❌ [RESET-PASSWORD] Password reset failed - Error: {}", e.getMessage(), e);
            throw e;
        }
    }

    @PostMapping("/change-password")
    @ApiMessage("Change password")
    public ResponseEntity<String> changePassword(@RequestBody ChangePasswordRequest changePasswordRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication != null ? authentication.getName() : "anonymous";

        log.info("🔐 [CHANGE-PASSWORD] Password change request - User: {}", username);

        try {
            authenicationService.handleChangePassword(changePasswordRequest, authentication);
            log.info("✅ [CHANGE-PASSWORD] Password changed successfully - User: {}", username);
            return ResponseEntity.ok().body("Change password successful");
        } catch (Exception e) {
            log.error("❌ [CHANGE-PASSWORD] Password change failed - User: {} | Error: {}",
                    username, e.getMessage(), e);
            throw e;
        }
    }

    /*@GetMapping("/oauth2/success")
    public ResponseEntity<?> success(@AuthenticationPrincipal OAuth2User principal) {
        // Lấy thông tin user từ GitLab
        String username = principal.getAttribute("username");
        String email = principal.getAttribute("email");
        String name = principal.getAttribute("name");

        // Tạo JWT token
        String token = jwtService.generateToken(username);

        // Trả JSON gồm token + thông tin user
        Map<String, Object> response = Map.of(
                "token", token,
                "username", username,
                "email", email,
                "name", name,
                "attributes", principal.getAttributes() // nếu muốn trả toàn bộ dữ liệu
        );

        return ResponseEntity.ok(response);
    }*/
}
