package com.proj.webprojrct.product.controller;

import com.proj.webprojrct.category.repo.CategoryRepo;
import com.proj.webprojrct.product.entity.Color;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.entity.Size;
import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.review.repository.ReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
@RequestMapping("/products")
public class ProductViewController {
    private final ProductService productService;
    private final CategoryRepo categoryRepo;
    private final ReviewRepository reviewRepository;

    @GetMapping
    public String productsPage(
            @RequestParam(required = false) List<Long> category
            , @RequestParam(required = false) String text
            , @RequestParam(required = false) String sort
            , @RequestParam(required = false) String price
            , @RequestParam(required = false, defaultValue = "1") Integer page
            , Model model
    ) {
        int pageIndex = page < 1 ? 0 : page - 1;
        int size = 12;
        // Add default data to model for page initialization
        Page<Product> productPage = productService.getFilteredProducts(Optional.ofNullable(category).orElse(List.of()), text, sort, price, pageIndex, size);

        model.addAttribute("products", productPage);
        model.addAttribute("currentPage", pageIndex);
        model.addAttribute("totalPages", productPage.getTotalPages());
        model.addAttribute("totalItems", productPage.getTotalElements());
        model.addAttribute("cates", categoryRepo.findByIsDelete(false));
        model.addAttribute("selectedPrice", price);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("pageTitle", "Sản phẩm - NiceStore");
        return "products";
    }

    @GetMapping("{id}")
    public String productDetailPage(@PathVariable Long id, Model model) {
        var p = productService.getProductById(id);
        model.addAttribute("productId", id);
        model.addAttribute("pageTitle", "Product Detail - NiceStore");
        model.addAttribute("product", p);
        model.addAttribute("sizes", Size.values());
        model.addAttribute("color", Color.values());

        model.addAttribute("reviews", reviewRepository.findByProductOrderByCreatedAtDesc(p));
        return "product-detail";
    }
}