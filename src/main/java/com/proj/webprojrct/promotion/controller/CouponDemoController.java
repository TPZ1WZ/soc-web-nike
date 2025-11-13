package com.proj.webprojrct.promotion.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller để hiển thị trang demo mã giảm giá
 */
@Controller
@RequestMapping("/demo")
public class CouponDemoController {

    /**
     * Hiển thị trang demo mã giảm giá
     */
    @GetMapping("/coupons")
    public String showCouponDemo() {
        return "coupon-demo";
    }
}