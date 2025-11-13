package com.proj.webprojrct.review.repository;

import com.proj.webprojrct.review.entity.ReviewReply;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewReplyRepository extends JpaRepository<ReviewReply, Long> {
    Page<ReviewReply> findByReviewIdAndParentIsNullOrderByCreatedAtAsc(Long reviewId, Pageable pageable);
}
