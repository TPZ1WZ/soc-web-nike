package com.proj.webprojrct.order.repository;

import com.proj.webprojrct.order.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
}
