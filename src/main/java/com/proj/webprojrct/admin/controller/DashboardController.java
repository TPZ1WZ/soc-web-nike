package com.proj.webprojrct.admin.controller;

import com.proj.webprojrct.admin.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

/**
 * Controller cho Admin Dashboard
 */
@Controller
@RequiredArgsConstructor
// @PreAuthorize("hasRole('ADMIN')") // Temporarily disabled for testing
public class DashboardController {

    private final DashboardService dashboardService;

    /**
     * Hiển thị trang dashboard
     */
    @GetMapping("/admin/dashboard")
    public String dashboardPage(Model model) {
        return "admin/dashboard";
    }

    /**
     * API lấy tất cả thống kê dashboard
     */
    @GetMapping("/api/admin/dashboard/statistics")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDashboardStatistics() {
        System.out.println("=== DASHBOARD API CALLED ===");
        try {
            Map<String, Object> stats = dashboardService.getDashboardStatistics();
            System.out.println("Dashboard stats: " + stats);
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            System.err.println("Error getting dashboard statistics: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * API lấy dữ liệu cho biểu đồ doanh thu
     */
    @GetMapping("/api/admin/dashboard/revenue-chart")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getRevenueChart() {
        Map<String, Object> chartData = dashboardService.getRevenueChart();
        return ResponseEntity.ok(chartData);
    }

    /**
     * API lấy top sản phẩm bán chạy
     */
    @GetMapping("/api/admin/dashboard/top-products")
    @ResponseBody
    public ResponseEntity<?> getTopProducts() {
        try {
            System.out.println("=== Getting top products ===");
            Object topProducts = dashboardService.getTopSellingProducts();
            System.out.println("Top products: " + topProducts);
            return ResponseEntity.ok(topProducts);
        } catch (Exception e) {
            System.err.println("Error getting top products: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(new java.util.ArrayList<>());
        }
    }

    /**
     * API lấy thống kê trạng thái đơn hàng
     */
    @GetMapping("/api/admin/dashboard/order-status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getOrderStatus() {
        Map<String, Object> orderStatus = dashboardService.getOrderStatusStats();
        return ResponseEntity.ok(orderStatus);
    }
}