package com.proj.webprojrct.order.controller;

import com.proj.webprojrct.order.dto.OrderDTO;
import com.proj.webprojrct.order.dto.ReviewOrderDTO;
import com.proj.webprojrct.order.entity.OrderItem;
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.payment.PaymentService;
import com.proj.webprojrct.payment.VnpayUtils;
import com.proj.webprojrct.review.entity.Review;
import com.proj.webprojrct.review.repository.ReviewRepository;
import com.proj.webprojrct.user.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@Controller
@RequestMapping("/orders")
@RequiredArgsConstructor
public class OrderWebController {
    private final OrderService orderService;
    private final OrderRepository orderRepository;
    private final PaymentService paymentService;
    private final ReviewRepository reviewRepository;

    @PostMapping("{id}/cancel")
    @ResponseBody
    public Object cancelOrder(@AuthenticationPrincipal User user, @PathVariable Long id) {
        if (user == null) {
            return Map.of("success", false, "message", "Vui lòng đăng nhập để hủy đơn hàng");
        }
        orderService.cancelOrder(user, id);
        return Map.of("success", true, "message", "Hủy đơn hàng thành công");
    }

    @GetMapping("history")
    public String orderHistoryPage(@AuthenticationPrincipal User user, Model model) {
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("orders", orderRepository.findByUserIdOrderByCreatedAtDesc(user.getId()));
        return "history-order";
    }

    @GetMapping("/history/{id}")
    public String orderDetail(@PathVariable Long id,
                              @AuthenticationPrincipal User user,
                              Model model) {
        var order = orderRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Không tìm thấy đơn hàng"));
        if (!order.getUser().getId().equals(user.getId())) {
            return "redirect:/orders/history";
        }
        var listReview = reviewRepository.findAllByUserAndProductIn(user,
                order.getItems().stream().map(OrderItem::getProduct).toList());
        OrderDTO orderDTO = orderService.toOrderDTO(order, user);
        orderDTO.getItems().stream().parallel().forEach(item -> {
            var review = listReview.stream()
                    .filter(r -> r.getProduct().getId().equals(item.getProductId()))
                    .findFirst();
            item.setReviewed(review.isPresent());
            item.setReview(
                    new ReviewOrderDTO(
                            review.map(Review::getRating).orElse(null),
                            review.map(Review::getComment).orElse(null),
                            review.map(Review::getTitle).orElse(null),
                            review.map(Review::getImages).orElse(null)
                    )
            );
        });
        model.addAttribute("order", orderDTO);

        return "order-detail";
    }

    @GetMapping("checkout")
    public String checkoutPage() {
        return "checkout";
    }

    @GetMapping("checkout/success")
    public String checkoutSuccessPage() {
        return "checkout-success";
    }

    @GetMapping("vnpay/callback")
    public String vnpayCallback(Model model, HttpServletRequest request) {
        String txn = request.getParameter("vnp_TxnRef");
        try {
            Map<String, Object> fields = new HashMap<>();
            for (var params = request.getParameterNames(); params.hasMoreElements(); ) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII);
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII);
                if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");
            String signValue = hashAllFields(fields);
            orderRepository.findByTxnId(txn).ifPresent(order -> {
                if (signValue.equals(vnp_SecureHash)) {
                    order.setStatus("00".equals(request.getParameter("vnp_ResponseCode")) ? "paid" : "failed");
                } else {
                    order.setStatus("failed");
                }
                orderRepository.save(order);
            });
        } catch (Exception e) {
            orderRepository.findByTxnId(txn).ifPresent(order -> {
                order.setStatus("failed");
                orderRepository.save(order);
            });
        }
        return "vnpay-callback";
    }

    public static String hashAllFields(Map<String, ?> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder sb = new StringBuilder();
        var itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) fields.get(fieldName);
            if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                sb.append(fieldName);
                sb.append("=");
                sb.append(fieldValue);
            }
            if (itr.hasNext()) {
                sb.append("&");
            }
        }
        return hmacSHA512(VnpayUtils.VNP_SECRET_KEY_VALUE, sb.toString());
    }

    public static String hmacSHA512(final String key, final String data) {
        try {

            if (key == null || data == null) {
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes();
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();

        } catch (Exception ex) {
            return "";
        }
    }

    public static class UserReviewProduct{
        private Long productId;
        private Long userId;

        public UserReviewProduct(Long productId, Long userId) {
            this.productId = productId;
            this.userId = userId;
        }

        public Long getProductId() {
            return productId;
        }

        public Long getUserId() {
            return userId;
        }
    }
}
