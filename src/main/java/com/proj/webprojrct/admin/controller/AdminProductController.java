package com.proj.webprojrct.admin.controller;

import com.proj.webprojrct.admin.repository.AdminProductRepository;
import com.proj.webprojrct.product.entity.Product;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controller quản lý sản phẩm trong admin dashboard
 */
@RestController
@RequestMapping("/admin/api/products")
@RequiredArgsConstructor
public class AdminProductController {

    private final AdminProductRepository adminProductRepository;

    // Helper methods để giảm code trùng lặp
    private <T> ResponseEntity<T> ok(T data) {
        return ResponseEntity.ok(data);
    }

    private ResponseEntity<Void> notFound() {
        return ResponseEntity.notFound().build();
    }

    /**
     * Lấy danh sách tất cả sản phẩm (có phân trang)
     */
    @GetMapping
    public ResponseEntity<Page<Product>> getAllProducts(Pageable pageable) {
        Page<Product> productPage = adminProductRepository.findAll(pageable);
        return ok(productPage);
    }

    /**
     * Lấy thông tin chi tiết một sản phẩm
     */
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        return adminProductRepository.findById(id)
                .map(this::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Tạo sản phẩm mới
     */
    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        Product savedProduct = adminProductRepository.save(product);
        return ok(savedProduct);
    }

    /**
     * Cập nhật thông tin sản phẩm
     */
    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(
            @PathVariable Long id,
            @RequestBody Product productRequest) {
        
        return adminProductRepository.findById(id)
                .map(existingProduct -> {
                    existingProduct.setName(productRequest.getName());
                    existingProduct.setDescription(productRequest.getDescription());
                    existingProduct.setPrice(productRequest.getPrice());

                    Product updatedProduct = adminProductRepository.save(existingProduct);
                    return ok(updatedProduct);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Xóa sản phẩm
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        return adminProductRepository.findById(id)
                .map(product -> {
                    adminProductRepository.delete(product);
                    return ResponseEntity.ok().<Void>build();
                })
                .orElse(notFound());
    }

    /**
     * Tìm kiếm sản phẩm theo tên
     */
    @GetMapping("/search")
    public ResponseEntity<List<Product>> searchProducts(
            @RequestParam(required = false) String keyword) {
        
        List<Product> products;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Sử dụng method có sẵn với Pageable, truyền default pageable
            Page<Product> productPage = adminProductRepository.findByNameContainingIgnoreCase(
                keyword.trim(), org.springframework.data.domain.PageRequest.of(0, 100));
            products = productPage.getContent();
        } else {
            products = adminProductRepository.findAll();
        }
        
        return ok(products);
    }

    /**
     * Thống kê tổng số sản phẩm
     */
    @GetMapping("/stats/total")
    public ResponseEntity<Long> getTotalProducts() {
        Long totalProducts = adminProductRepository.count();
        return ok(totalProducts);
    }

    /**
     * Thống kê sản phẩm hết hàng
     */
    @GetMapping("/stats/out-of-stock")
    public ResponseEntity<Long> getOutOfStockCount() {
        // Tạm thời return 0, cần implement method trong repository
        Long outOfStock = 0L; // adminProductRepository.countOutOfStockProducts();
        return ok(outOfStock);
    }

    /**
     * Thống kê sản phẩm sắp hết hàng
     */
    @GetMapping("/stats/low-stock")
    public ResponseEntity<Long> getLowStockCount() {
        // Tạm thời return 0, cần implement method trong repository
        Long lowStock = 0L; // adminProductRepository.countLowStockProducts();
        return ok(lowStock);
    }

    /**
     * Lấy top sản phẩm bán chạy
     */
    @GetMapping("/top-selling")
    public ResponseEntity<List<Object[]>> getTopSellingProducts(
            @RequestParam(defaultValue = "10") Integer limit) {
        // Tạm thời return empty list, cần implement method trong repository
        List<Object[]> topProducts = java.util.Collections.emptyList(); // adminProductRepository.findTopSellingProducts(limit);
        return ok(topProducts);
    }
}