package com.proj.webprojrct.product;

import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.product.entity.Product;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/test")
@RequiredArgsConstructor
public class TestController {

    private final ProductRepository productRepository;

    @GetMapping("/category-filter")
    public Object testCategoryFilter(
            @RequestParam(required = false) List<Long> categoryIds,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        try {
            System.out.println("DEBUG: categoryIds = " + categoryIds);
            
            Pageable pageable = PageRequest.of(page, size);
            
            if (categoryIds != null && !categoryIds.isEmpty()) {
                System.out.println("DEBUG: Using category filter with IDs: " + categoryIds);
                Page<Product> result = productRepository.findWithFiltersAndCategories(
                    null, // name (no name filter for this test)
                    null, // minPrice
                    null, // maxPrice
                    categoryIds,
                    pageable
                );
                System.out.println("DEBUG: Found " + result.getTotalElements() + " products");
                return result;
            } else {
                System.out.println("DEBUG: No category filter, getting all products");
                Page<Product> result = productRepository.findByIsDelete(false, pageable);
                System.out.println("DEBUG: Found " + result.getTotalElements() + " total products");
                return result;
            }
        } catch (Exception e) {
            System.err.println("ERROR in testCategoryFilter: " + e.getMessage());
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }
}