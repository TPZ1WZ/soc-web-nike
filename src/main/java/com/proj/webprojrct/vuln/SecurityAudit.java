package com.proj.webprojrct.vuln;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * ============================================================================
 * LAB SOC - Tiện ích ghi log sự kiện bảo mật.
 * Mọi dòng ghi qua đây đi vào logs/security.log (xem logback-spring.xml,
 * logger tên "SECURITY"). Định dạng key=value cố định để Wazuh decoder dễ parse.
 *
 * ⚠️ Chỉ dùng cho môi trường lab. KHÔNG dùng ở production.
 * ============================================================================
 */
@Component
public class SecurityAudit {

    // Logger tên "SECURITY" -> khớp <logger name="SECURITY"> trong logback-spring.xml
    private static final Logger SEC = LoggerFactory.getLogger("SECURITY");

    /** Lấy IP thật của client (ưu tiên X-Forwarded-For khi có reverse proxy). */
    public String clientIp(HttpServletRequest req) {
        String xff = req.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) {
            return xff.split(",")[0].trim();
        }
        return req.getRemoteAddr();
    }

    /** Ghi 1 sự kiện bảo mật dạng: event=<EVENT> ip=<IP> uri=<URI> <chi tiết> */
    public void log(String event, HttpServletRequest req, String details) {
        SEC.warn("event={} ip={} method={} uri=\"{}\" ua=\"{}\" {}",
                event,
                clientIp(req),
                req.getMethod(),
                req.getRequestURI() + (req.getQueryString() != null ? "?" + req.getQueryString() : ""),
                safe(req.getHeader("User-Agent")),
                details == null ? "" : details);
    }

    /** Ghi sự kiện kèm exception (ví dụ SQLException) để có stacktrace trong log. */
    public void logError(String event, HttpServletRequest req, String details, Throwable ex) {
        SEC.error("event={} ip={} method={} uri=\"{}\" {} error=\"{}\"",
                event,
                clientIp(req),
                req.getMethod(),
                req.getRequestURI() + (req.getQueryString() != null ? "?" + req.getQueryString() : ""),
                details == null ? "" : details,
                ex.getMessage(),
                ex);
    }

    private String safe(String s) {
        if (s == null) return "-";
        return s.replace("\"", "'").replace("\n", " ").replace("\r", " ");
    }
}
