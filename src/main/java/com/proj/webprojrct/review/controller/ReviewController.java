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

import java.io.IOException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;

@Controller
@RequestMapping("reviews")
@RequiredArgsConstructor
@Log
public class ReviewController {
    private final ProductRepository productRepository;
    private final ReviewRepository reviewRepository;

    @PostMapping("/add/{productId}")
    @ResponseBody
    public Object addReview(@PathVariable Long productId, @AuthenticationPrincipal User user, @RequestParam int rating, @RequestParam(required = false) String title, @RequestParam(required = false) String comment, @RequestParam(required = false, name = "images") MultipartFile[] files) {

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
            return Map.of("success", true, "message", "Đánh giá thành công!", "reviewId", review.getId());
        } catch (Exception e) {
            log.log(Level.SEVERE, e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Có lỗi khi gửi đánh giá: " + e.getMessage()));
        }
    }
}