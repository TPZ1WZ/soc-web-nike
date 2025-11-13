package com.proj.webprojrct.product.controller;

import com.proj.webprojrct.category.repo.CategoryRepo;
import com.proj.webprojrct.product.dto.ProductCreateDto;
import com.proj.webprojrct.product.dto.ProductUpdateDto;
import com.proj.webprojrct.product.entity.Color;
import com.proj.webprojrct.product.entity.Size;
import com.proj.webprojrct.product.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/products")
public class ProductWebController {

    private final ProductService productService;
    private final CategoryRepo categoryRepo;

    @GetMapping
    public String getProductsPage(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            Model model) {
        
        model.addAttribute("products", productService.searchProducts(name, minPrice, maxPrice));
        model.addAttribute("searchName", name);
        model.addAttribute("searchMinPrice", minPrice);
        model.addAttribute("searchMaxPrice", maxPrice);
        
        return "admin/products";
    }

    @GetMapping("/create")
    public String getCreatePage(Model model) {
        model.addAttribute("product", new ProductCreateDto());
        model.addAttribute("categories", categoryRepo.findByIsDelete(false));
        var listColors = Color.values();
        var listSizes = Size.values();
        model.addAttribute("listColors", Arrays.asList(listColors));
        model.addAttribute("listSizes", Arrays.asList(listSizes));
        return "admin/product-create";
    }

    @PostMapping("/create")
    public String createProduct(@ModelAttribute("product") ProductCreateDto productDto, 
                               RedirectAttributes redirectAttributes) {
        try {
            var createdProduct = productService.createProduct(productDto);
            redirectAttributes.addFlashAttribute("successMessage", "Product created successfully!");
            return "redirect:/products/" + createdProduct.getId();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error creating product: " + e.getMessage());
            return "redirect:/products/create";
        }
    }

    @GetMapping("/edit/{id}")
    public String getEditPage(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            var product = productService.getProductById(id);
            model.addAttribute("product", product);
            model.addAttribute("categories", categoryRepo.findByIsDelete(false));
            var listColors = Color.values();
            var listSizes = Size.values();
            model.addAttribute("listColors", Arrays.asList(listColors));
            model.addAttribute("listSizes", Arrays.asList(listSizes));
            return "admin/products-edit";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "❌ Product not found!");
            return "redirect:/admin/products";
        }
    }

    @PostMapping("/edit/{id}")
    public String updateProduct(@PathVariable Long id,
                               @ModelAttribute("product") ProductUpdateDto productDto,
                               RedirectAttributes redirectAttributes) {
        try {
            productService.updateProduct(id, productDto);
            redirectAttributes.addFlashAttribute("successMessage", "Product updated successfully!");
            return "redirect:/products/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating product: " + e.getMessage());
            return "redirect:/products/edit/" + id;
        }
    }

    @PostMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            productService.deleteProduct(id);
            redirectAttributes.addFlashAttribute("successMessage", "Product deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting product: " + e.getMessage());
        }
        return "redirect:/admin/products";
    }
}