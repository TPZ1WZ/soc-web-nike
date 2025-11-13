package com.proj.webprojrct.order.controller;

import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@AllArgsConstructor
@RequestMapping("/api/v1/orders")
public class OrderController {
    private final OrderService orderService;


    @PostMapping("checkout")
    public Object createOrder(@AuthenticationPrincipal User user, @RequestBody OrderRequest order) {
        if (user == null) {
            return Map.of("status", false, "message", "Vui lòng đăng nhập");
        }
        var paymentUrl = orderService.placeOrder(user, order);
        var result = new HashMap<String, Object>();
        result.put("status", true);
        result.put("message", "✅ Đặt hàng thành công");
        result.put("paymentUrl", paymentUrl);
        return result;
    }


    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class OrderRequest {
        private String shippingAddress;
        private String paymentMethod;
        private String phone;
        private String couponCode;
    }

}
