package com.proj.webprojrct.config;

import com.proj.webprojrct.product.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class ViewController {
    private static final Logger logger = LoggerFactory.getLogger(ViewController.class);
    private final ProductService productService;
    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("pageTitle", "Trang chủ");
        model.addAttribute("newProducts", productService.getNewProducts(12));
        return "home"; // This will render home.html (Thymeleaf)
    }

    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("pageTitle", "Trang chủ");
        model.addAttribute("newProducts", productService.getNewProducts(12));
        return "home"; // This will render home.html (Thymeleaf)
    }

    @GetMapping("/login")
    public String login(Model model) {
        model.addAttribute("pageTitle", "Đăng nhập");
        return "login"; // This will render login.html (Thymeleaf)
    }

    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("pageTitle", "Đăng ký");
        return "register"; // This will render register.html (Thymeleaf)
    }
    
    @GetMapping("/forgot-password")
    public String forgotPassword(Model model) {
        model.addAttribute("pageTitle", "Quên mật khẩu");
        return "forgot-password"; // This will render forgot-password.html (Thymeleaf)
    }
    
    @GetMapping("/test")
    public String test(Model model) {
        model.addAttribute("pageTitle", "Test");
        return "test"; // This will render test.html (Thymeleaf)
    }
}