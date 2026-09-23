package com.proj.webprojrct.review.controller;

import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.review.entity.Review;
import com.proj.webprojrct.review.repository.ReviewRepository;
import com.proj.webprojrct.user.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.java.Log;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.proj.webprojrct.vuln.SecurityAudit;
import jakarta.servlet.http.HttpServletRequest;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;

@Controller
@RequestMapping("reviews")
@RequiredArgsConstructor
@Log
public class ReviewController {
    private final ProductRepository productRepository;
    private final ReviewRepository reviewRepository;
    // ⚠️ LAB SOC #4: ghi log upload ảnh review
    private final SecurityAudit securityAudit;

    @PostMapping("/add/{productId}")
    @ResponseBody
    public Object addReview(@PathVariable Long productId, @AuthenticationPrincipal User user, @RequestParam int rating, @RequestParam(required = false) String title, @RequestParam(required = false) String comment, @RequestParam(required = false, name = "images") MultipartFile[] files, HttpServletRequest request) {

        try {
            Product product = productRepository.findById(productId).orElseThrow(() -> new IllegalArgumentException("Invalid product"));
            boolean exists = reviewRepository.existsByUserAndProduct(user, product);
            if (exists) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Bạn đã đánh giá sản phẩm này rồi!"));
            }
            List<String> imageUrls = new ArrayList<>();

            if (files != null) {
                for (MultipartFile file : files) {
                    if (!file.isEmpty()) {
                        try {
                            byte[] bytes = file.getBytes();
                            String base64 = Base64.getEncoder().encodeToString(bytes);
                            String mimeType = file.getContentType();
                            String dataUri = "data:" + mimeType + ";base64," + base64;
                            imageUrls.add(dataUri);

                            // ⚠️⚠️ LAB SOC #4 - FILE UPLOAD: ghi file ra đĩa bằng ĐÚNG tên gốc,
                            // KHÔNG kiểm tra đuôi/MIME/nội dung -> có thể upload webshell (T1505.003).
                            String original = file.getOriginalFilename();
                            String ext = (original != null && original.contains("."))
                                    ? original.substring(original.lastIndexOf('.') + 1).toLowerCase(Locale.ROOT) : "";
                            File dir = new File("uploads/reviews");
                            if (!dir.exists()) dir.mkdirs();
                            File dest = Paths.get("uploads/reviews", original).toFile();
                            file.transferTo(dest.getAbsoluteFile());

                            boolean dangerous = ext.matches("php|jsp|jspx|asp|aspx|sh|exe|jar|war");
                            securityAudit.log(dangerous ? "FILE_UPLOAD_SUSPICIOUS" : "FILE_UPLOAD", request,
                                    "filename=\"" + original + "\" ext=" + ext + " size=" + file.getSize()
                                    + " saved=\"" + dest.getPath() + "\"");
                        } catch (IOException e) {
                            log.log(Level.SEVERE, "Error processing file upload", e);
                        }
                    }
                }
            }

            Review review = new Review();
            review.setProduct(product);
            review.setUser(user);
            review.setRating(rating);
            review.setTitle(title);
            review.setComment(comment);
            review.setImages(imageUrls);
            review.setIsHidden(false);
            review.setLikeCount(0);
            review.setDislikeCount(0);
            reviewRepository.save(review);

            // ⚠️ LAB SOC #8 - STORED XSS: phát hiện payload JS trong đánh giá -> ghi log cho Wazuh
            String combined = ((title == null ? "" : title) + " " + (comment == null ? "" : comment));
            if (combined.matches("(?is).*(<script|onerror\\s*=|onload\\s*=|<img|<svg|javascript:|onmouseover\\s*=).*")) {
                securityAudit.log("XSS_STORED", request,
                        "productId=" + productId + " reviewId=" + review.getId()
                        + " payload=\"" + combined.replace("\"", "'").trim() + "\"");
            }

            return Map.of("success", true, "message", "Đánh giá thành công!", "reviewId", review.getId());
        } catch (Exception e) {
            log.log(Level.SEVERE, e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Có lỗi khi gửi đánh giá: " + e.getMessage()));
        }
    }
}