package com.proj.webprojrct.admin.service;

import com.proj.webprojrct.admin.repository.AdminOrderRepository;
import com.proj.webprojrct.admin.repository.AdminProductRepository;
import com.proj.webprojrct.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Service để tính toán thống kê cho Dashboard
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class DashboardService {

    private final UserRepository userRepository;
    private final AdminOrderRepository orderRepository;
    private final AdminProductRepository productRepository;

    /**
     * Lấy tất cả thống kê cho dashboard
     */
    public Map<String, Object> getDashboardStatistics() {
        log.info("=== Getting dashboard statistics ===");
        
        Map<String, Object> stats = new HashMap<>();
        
        // Thống kê người dùng
        Long totalUsers = getTotalUsers();
        log.info("Total users: {}", totalUsers);
        stats.put("totalUsers", totalUsers);
        
        // Thống kê doanh thu
        BigDecimal totalRevenue = getTotalRevenue();
        log.info("Total revenue: {}", totalRevenue);
        stats.put("totalRevenue", totalRevenue);
        
        // Thống kê đơn hàng đã hoàn thành
        Long completedOrders = getCompletedOrders();
        log.info("Completed orders: {}", completedOrders);
        stats.put("totalOrders", completedOrders);
        
        // Thống kê sản phẩm (mock data tạm thời)
        Long totalProducts = getTotalProducts();
        log.info("Total products: {}", totalProducts);
        stats.put("totalProducts", totalProducts);
        
        // Thống kê theo tháng
        Map<String, Object> monthlyStats = getMonthlyStatistics();
        log.info("Monthly stats: {}", monthlyStats);
        stats.put("monthlyStats", monthlyStats);
        
        log.info("Final stats: {}", stats);
        return stats;
    }

    /**
     * Lấy tổng số người dùng
     */
    public Long getTotalUsers() {
        Long count = userRepository.count();
        log.info("User count from repository: {}", count);
        return count;
    }

    /**
     * Lấy tổng doanh thu từ đơn hàng đã hoàn thành
     */
    public BigDecimal getTotalRevenue() {
        try {
            Double revenue = orderRepository.calculateTotalRevenue();
            BigDecimal result = revenue != null ? BigDecimal.valueOf(revenue) : BigDecimal.ZERO;
            log.info("Real revenue from database: {}", result);
            return result;
        } catch (Exception e) {
            log.error("Error calculating total revenue: ", e);
            return BigDecimal.ZERO;
        }
    }

    /**
     * Lấy tổng số đơn hàng
     */
    public Long getTotalOrders() {
        try {
            Long orders = orderRepository.count();
            log.info("Real orders count from database: {}", orders);
            return orders;
        } catch (Exception e) {
            log.error("Error counting total orders: ", e);
            return 0L;
        }
    }

    /**
     * Lấy số đơn hàng đã hoàn thành
     */
    public Long getCompletedOrders() {
        try {
            Long completedOrders = orderRepository.countByStatus("completed");
            log.info("Real completed orders count from database: {}", completedOrders);
            return completedOrders != null ? completedOrders : 0L;
        } catch (Exception e) {
            log.error("Error counting completed orders: ", e);
            return 0L;
        }
    }

    /**
     * Lấy tổng số sản phẩm
     */
    public Long getTotalProducts() {
        try {
            Long products = productRepository.count();
            log.info("Real products count from database: {}", products);
            return products;
        } catch (Exception e) {
            log.error("Error counting total products: ", e);
            return 0L;
        }
    }

    /**
     * Lấy thống kê theo tháng hiện tại
     */
    public Map<String, Object> getMonthlyStatistics() {
        Map<String, Object> monthlyStats = new HashMap<>();
        
        try {
            LocalDateTime now = LocalDateTime.now();
            int currentYear = now.getYear();
            int currentMonth = now.getMonthValue();
            
            // Người dùng mới tháng này - tạm thời dùng tổng số user
            Long totalUsers = userRepository.count();
            monthlyStats.put("newUsersThisMonth", totalUsers > 10 ? totalUsers / 10 : totalUsers);
            
            // Doanh thu tháng này
            LocalDateTime startOfMonth = now.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
            LocalDateTime endOfMonth = startOfMonth.plusMonths(1);
            Double revenueThisMonth = orderRepository.calculateRevenueInPeriod(startOfMonth, endOfMonth);
            monthlyStats.put("revenueThisMonth", revenueThisMonth != null ? BigDecimal.valueOf(revenueThisMonth) : BigDecimal.ZERO);
            
            // Đơn hàng tháng này
            Long ordersThisMonth = orderRepository.countMonthlyOrders(currentYear, currentMonth);
            monthlyStats.put("ordersThisMonth", ordersThisMonth);
            
            // Số lượng sản phẩm hiện có
            Long totalProducts = productRepository.count();
            monthlyStats.put("topSellingProducts", totalProducts);
            
            log.info("Monthly stats calculated: {}", monthlyStats);
            
        } catch (Exception e) {
            log.error("Error calculating monthly statistics: ", e);
            // Fallback values nếu có lỗi
            monthlyStats.put("newUsersThisMonth", 0L);
            monthlyStats.put("revenueThisMonth", BigDecimal.ZERO);
            monthlyStats.put("ordersThisMonth", 0L);
            monthlyStats.put("topSellingProducts", 0L);
        }
        
        return monthlyStats;
    }

    /**
     * Lấy thống kê cho biểu đồ doanh thu 7 ngày gần đây
     */
    public Map<String, Object> getRevenueChart() {
        Map<String, Object> chartData = new HashMap<>();
        
        // Mock data cho 7 ngày gần đây
        String[] days = {"CN", "T2", "T3", "T4", "T5", "T6", "T7"};
        Long[] revenues = {850000L, 1200000L, 950000L, 1800000L, 1100000L, 2200000L, 1650000L};
        
        chartData.put("labels", days);
        chartData.put("data", revenues);
        
        return chartData;
    }

    /**
     * Lấy thống kê top sản phẩm bán chạy
     */
    public Object getTopSellingProducts() {
        try {
            // Lấy dữ liệu thực từ database
            var topProducts = productRepository.findTopSellingProducts();
            log.info("Real top products from database: {}", topProducts);
            
            if (topProducts == null || topProducts.isEmpty()) {
                log.warn("No top products found in database");
                return new java.util.ArrayList<>();
            }
            
            return topProducts;
        } catch (Exception e) {
            log.error("Error getting top selling products: ", e);
            return new java.util.ArrayList<>();
        }
    }

    /**
     * Lấy thống kê đơn hàng theo trạng thái
     */
    public Map<String, Object> getOrderStatusStats() {
        Map<String, Object> statusStats = new HashMap<>();
        
        try {
            // Lấy thống kê thực từ database theo các trạng thái trong entity
            // Entity có: pending, confirmed, shipping, completed, canceled
            Long pendingCount = orderRepository.countByStatus("pending");
            Long confirmedCount = orderRepository.countByStatus("confirmed"); // Đang xử lý
            Long shippingCount = orderRepository.countByStatus("shipping");
            Long completedCount = orderRepository.countByStatus("completed"); // Đã giao
            Long canceledCount = orderRepository.countByStatus("canceled");
            
            // Map với UI: pending -> pending, confirmed -> processing, shipping -> shipping, completed -> delivered, canceled -> cancelled
            statusStats.put("pending", pendingCount != null ? pendingCount : 0L);
            statusStats.put("processing", confirmedCount != null ? confirmedCount : 0L);
            statusStats.put("shipping", shippingCount != null ? shippingCount : 0L);
            statusStats.put("delivered", completedCount != null ? completedCount : 0L);
            statusStats.put("cancelled", canceledCount != null ? canceledCount : 0L);
            
            log.info("Order status stats from database: {}", statusStats);
            
        } catch (Exception e) {
            log.error("Error getting order status stats: ", e);
            // Fallback values
            statusStats.put("pending", 0L);
            statusStats.put("processing", 0L);
            statusStats.put("shipping", 0L);
            statusStats.put("delivered", 0L);
            statusStats.put("cancelled", 0L);
        }
        
        return statusStats;
    }
}