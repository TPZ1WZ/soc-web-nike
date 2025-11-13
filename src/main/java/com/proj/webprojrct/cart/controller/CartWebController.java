package com.proj.webprojrct.cart.controller;

import com.proj.webprojrct.cart.dto.CartDTO;
import com.proj.webprojrct.cart.service.CartService;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.common.utils.SecurityUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/carts")
public class CartWebController {
    private final CartService cartService;
    private final UserRepository userRepository;

    @GetMapping
    public Object getCartByUser(@AuthenticationPrincipal User user, Model model) {
        if (user == null) {
            return "redirect:/login?error=user_not_found";
        }
        try {
            var cart = cartService.getCartByUser(user);
            model.addAttribute("cart", cart);
            return "cart";
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải giỏ hàng. Vui lòng thử lại.");
            return "error";
        }
    }
}
