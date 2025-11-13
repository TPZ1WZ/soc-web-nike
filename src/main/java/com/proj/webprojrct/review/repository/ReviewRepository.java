package com.proj.webprojrct.review.repository;

import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.review.entity.Review;
import com.proj.webprojrct.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByProductOrderByCreatedAtDesc(Product product);
    Optional<Review> findByUserAndProduct(User user, Product product);
    boolean existsByUserAndProduct(User user, Product product);
    List<Review> findAllByUserAndProductIn(User user, List<Product> products);
}