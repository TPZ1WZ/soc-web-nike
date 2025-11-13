<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ELEGANCE | Luxury Fashion</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/shop-icons.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <!-- Top Bar -->
    <div class="bg-light py-1">
        <div class="container d-flex justify-content-end align-items-center">
            <a href="#" class="text-decoration-none me-3 small text-dark">Tìm Cửa Hàng</a>
            <span class="small text-dark mx-2">|</span>
            <a href="#" class="text-decoration-none me-3 small text-dark">Trợ Giúp</a>
            <span class="small text-dark mx-2">|</span>
            <a href="#" class="text-decoration-none me-3 small text-dark">Tham Gia</a>
            <span class="small text-dark mx-2">|</span>
            <a href="#" class="text-decoration-none small text-dark">Đăng Nhập</a>
        </div>
    </div>
    
    <!-- Main Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light navbar-custom shadow-sm py-2 sticky-top bg-white">
        <div class="container">
            <a class="navbar-brand fs-3" href="#">
                <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="NICE" height="40">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item mx-3">
                        <a class="nav-link fw-bold" href="#" id="newFeaturedMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">Mới & Nổi Bật</a>
                        <div class="dropdown-menu mega-menu p-3" aria-labelledby="newFeaturedMenu">
                            <div class="row">
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Nổi Bật</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Hàng Mới Về</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Sản Phẩm Bán Chạy</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Thành Viên Đặc Quyền</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tùy Chỉnh Với NICE By You</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Đang Thịnh Hành</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bộ Sưu Tập Jordan</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Đang Thịnh Hành</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Bộ Sưu Tập Mùa Hè</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bộ Sưu Tập Structure 26</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Xu Hướng Mới Nhất</a></li>
                                        <li><a class="dropdown-item py-1" href="#">NICE 24/7</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bộ Sưu Tập Retro Running</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bộ Lọc Giày Chạy Bộ</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Shop Icons</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Air Force 1</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Air Jordan 1</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Air Max</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Dunk</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Cortez</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Blazer</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Shop By Sport</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Chạy Bộ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bóng Rổ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bóng Đá</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Golf</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tennis</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tập Luyện</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li class="nav-item mx-3">
                        <a class="nav-link fw-bold" href="#" id="menMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">Nam</a>
                        <div class="dropdown-menu mega-menu p-3" aria-labelledby="menMenu">
                            <div class="row">
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Tất Cả Sản Phẩm Nam</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Giày</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Quần Áo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Phụ Kiện</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Hàng Mới Về</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bộ Sưu Tập</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Giày Nam</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Tất Cả Giày</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Lifestyle</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Chạy Bộ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bóng Rổ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bóng Đá</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tập Luyện</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Quần Áo Nam</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Tất Cả Quần Áo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Áo Thun & Áo Polo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Áo Hoodie & Áo Khoác</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Quần</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bộ Đồ Thể Thao</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Quần Short</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Shop By Sport</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Chạy Bộ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bóng Rổ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bóng Đá</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Golf</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tennis</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tập Luyện</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li class="nav-item mx-3">
                        <a class="nav-link fw-bold" href="#" id="womenMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">Nữ</a>
                        <div class="dropdown-menu mega-menu p-3" aria-labelledby="womenMenu">
                            <!-- Similar structure to men's menu -->
                            <div class="row">
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Tất Cả Sản Phẩm Nữ</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Giày</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Quần Áo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Phụ Kiện</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Hàng Mới Về</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bộ Sưu Tập</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Giày Nữ</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Tất Cả Giày</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Lifestyle</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Chạy Bộ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tập Luyện</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tennis</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Quần Áo Nữ</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Tất Cả Quần Áo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Áo Thun & Áo Polo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Áo Hoodie & Áo Khoác</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Leggings & Quần</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Áo Thể Thao</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Quần Short</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Shop By Sport</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Chạy Bộ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Training & Gym</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Yoga</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Golf</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tennis</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Dance</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li class="nav-item mx-3">
                        <a class="nav-link fw-bold" href="#" id="kidsMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">Trẻ Em</a>
                        <div class="dropdown-menu mega-menu p-3" aria-labelledby="kidsMenu">
                            <!-- Similar structure to men's menu -->
                            <div class="row">
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Tất Cả Sản Phẩm Trẻ Em</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Giày</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Quần Áo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Phụ Kiện</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Hàng Mới Về</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Theo Độ Tuổi</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Trẻ Nhỏ (1-4 tuổi)</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Trẻ Em (4-7 tuổi)</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Thiếu Niên (8-16 tuổi)</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Quần Áo Trẻ Em</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Tất Cả Quần Áo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Áo Thun & Áo Polo</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Áo Hoodie & Áo Khoác</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Quần & Leggings</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bộ Đồ Thể Thao</a></li>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <h5 class="fw-bold mb-3">Shop By Sport</h5>
                                    <ul class="list-unstyled">
                                        <li><a class="dropdown-item py-1" href="#">Chạy Bộ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bóng Đá</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Bóng Rổ</a></li>
                                        <li><a class="dropdown-item py-1" href="#">Tennis</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li class="nav-item mx-3">
                        <a class="nav-link fw-bold" href="#">Khuyến Mãi</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <div class="position-relative me-3">
                        <input type="text" class="form-control form-control-sm rounded-pill bg-light border-0" placeholder="Tìm kiếm...">
                        <i class="fas fa-search position-absolute end-0 top-50 translate-middle-y me-2"></i>
                    </div>
                    <a href="#" class="me-3 text-dark fs-5"><i class="far fa-heart"></i></a>
                    <a href="#" class="text-dark fs-5"><i class="fas fa-shopping-bag"></i></a>
                </div>
                <div class="d-flex align-items-center">
                    <a href="#" class="me-3 text-dark"><i class="fas fa-search"></i></a>
                    <a href="#" class="me-3 text-dark"><i class="fas fa-user"></i></a>
                    <a href="#" class="text-dark"><i class="fas fa-shopping-bag"></i></a>
                </div>
            </div>
        </div>
    </nav>
    
    <!-- Hero Section -->
    <section class="hero-section p-0">
        <div class="position-relative">
            <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/w_1423,c_limit/9064fe25-87b8-4d3d-9723-eeb57f1c6797/nike-just-do-it.jpg" alt="Hero Banner" class="img-fluid w-100">
            <div class="position-absolute top-50 start-0 translate-middle-y p-5 text-dark">
                <h1 class="display-4 fw-bold mb-3">JUST DO IT.</h1>
                <h2 class="h3 fw-bold mb-4">BỘ SƯU TẬP MÙA THU 2023</h2>
                <p class="fs-5 mb-4">Khám phá những thiết kế mới nhất từ NICE</p>
                <div>
                    <a href="#" class="btn btn-dark rounded-pill px-4 py-2 me-3 fw-bold">MUA SẮM</a>
                    <a href="#" class="btn btn-outline-dark rounded-pill px-4 py-2 fw-bold">TÌM HIỂU THÊM</a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Main Categories Section -->
    <section class="py-5">
        <div class="container">
            <h4 class="mb-4 fw-bold">DANH MỤC MUA SẮM CHÍNH</h4>
            
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="position-relative overflow-hidden rounded">
                        <a href="/products/men">
                            <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/h_700,c_limit/eb089201-96c3-4ec6-b1c3-53e2cfe1bb95/nike-just-do-it.jpg" alt="Men's Fashion" class="img-fluid w-100 hover-zoom">
                            <div class="position-absolute bottom-0 start-0 p-4">
                                <h3 class="fw-bold text-white mb-3">NAM</h3>
                                <a href="/products/men" class="btn btn-light rounded-pill px-4 py-2 fw-bold">MUA SẮM</a>
                            </div>
                        </a>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="position-relative overflow-hidden rounded">
                        <a href="/products/women">
                            <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/h_700,c_limit/575583b8-d2a5-4fe7-83b9-1f5a3e60e319/nike-just-do-it.jpg" alt="Women's Fashion" class="img-fluid w-100 hover-zoom">
                            <div class="position-absolute bottom-0 start-0 p-4">
                                <h3 class="fw-bold text-white mb-3">NỮ</h3>
                                <a href="/products/women" class="btn btn-light rounded-pill px-4 py-2 fw-bold">MUA SẮM</a>
                            </div>
                        </a>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="position-relative overflow-hidden rounded">
                        <a href="/products/kids">
                            <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/h_700,c_limit/9c3243c5-8511-46aa-a181-fef6e955e436/nike-just-do-it.jpg" alt="Kids' Fashion" class="img-fluid w-100 hover-zoom">
                            <div class="position-absolute bottom-0 start-0 p-4">
                                <h3 class="fw-bold text-white mb-3">TRẺ EM</h3>
                                <a href="/products/kids" class="btn btn-light rounded-pill px-4 py-2 fw-bold">MUA SẮM</a>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Shop by Icons -->
    <section class="shop-icons-section">
        <div class="container">
            <h2 class="shop-icons-title">Shop by Icons</h2>
            
            <div class="shop-icons-nav">
                <div class="nav-arrow prev">
                    <i class="fas fa-chevron-left"></i>
                </div>
                
                <div class="shop-icons-container">
                    <a href="/products/air-jordan-1" class="text-decoration-none">
                        <div class="icon-card">
                            <img src="<c:url value='/resources/img/Icons/jordan1.jpg'/>" alt="Air Jordan 1" class="icon-image">
                            <div class="icon-label">Air Jordan 1</div>
                        </div>
                    </a>
                    
                    <a href="/products/air-force-1" class="text-decoration-none">
                        <div class="icon-card">
                            <img src="<c:url value='/resources/img/Icons/airForce1.jpg'/>" alt="Air Force 1" class="icon-image">
                            <div class="icon-label">Air Force 1</div>
                        </div>
                    </a>
                    
                    <a href="/products/v2k" class="text-decoration-none">
                        <div class="icon-card">
                            <img src="<c:url value='/resources/img/Icons/v2k.jpg'/>" alt="V2K" class="icon-image">
                            <div class="icon-counter">1/8</div>
                            <div class="icon-label">V2K</div>
                        </div>
                    </a>
                    
                    <a href="/products/metcon" class="text-decoration-none">
                        <div class="icon-card">
                            <img src="<c:url value='/resources/img/Icons/metcon.jpg'/>" alt="Metcon" class="icon-image">
                            <div class="icon-label">Metcon</div>
                        </div>
                    </a>
                    
                    <a href="/products/air-max-dn" class="text-decoration-none">
                        <div class="icon-card">
                            <img src="<c:url value='/resources/img/Icons/airMaxDn.jpg'/>" alt="Air Max Dn" class="icon-image">
                            <div class="icon-label">Air Max Dn</div>
                        </div>
                    </a>
                </div>
                
                <div class="nav-arrow next">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>
        </div>
    </section>
            </div>
        </div>
    </section>
    
    <!-- Shop By Sport -->
    <section class="py-5">
        <div class="container">
            <h4 class="mb-4 fw-bold">SHOP BY SPORT</h4>
            
            <div class="row g-4">
                <div class="col-md-4 col-6">
                    <a href="/products/sport/running" class="text-decoration-none">
                        <div class="position-relative overflow-hidden rounded">
                            <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/w_467,c_limit/505f6f81-73da-4429-9e70-49a1967578d1/nike-just-do-it.jpg" alt="Running" class="img-fluid w-100 hover-zoom">
                            <div class="position-absolute bottom-0 start-0 p-4">
                                <h5 class="fw-bold text-white">CHẠY BỘ</h5>
                            </div>
                        </div>
                    </a>
                </div>
                
                <div class="col-md-4 col-6">
                    <a href="/products/sport/basketball" class="text-decoration-none">
                        <div class="position-relative overflow-hidden rounded">
                            <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/w_467,c_limit/65dd3a89-4461-4ed5-8f11-d9bd7b6ab8cd/nike-just-do-it.jpg" alt="Basketball" class="img-fluid w-100 hover-zoom">
                            <div class="position-absolute bottom-0 start-0 p-4">
                                <h5 class="fw-bold text-white">BÓNG RỔ</h5>
                            </div>
                        </div>
                    </a>
                </div>
                
                <div class="col-md-4 col-6">
                    <a href="/products/sport/football" class="text-decoration-none">
                        <div class="position-relative overflow-hidden rounded">
                            <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/w_467,c_limit/6ae71a68-9e72-46ab-b7d1-404d814d89a9/nike-just-do-it.jpg" alt="Football" class="img-fluid w-100 hover-zoom">
                            <div class="position-absolute bottom-0 start-0 p-4">
                                <h5 class="fw-bold text-white">BÓNG ĐÁ</h5>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Featured Products -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0">SẢN PHẨM NỔI BẬT</h4>
                <a href="#" class="text-decoration-none text-dark">Xem Tất Cả</a>
            </div>
            
            <div class="row g-4">
                <div class="col-6 col-md-3">
                    <div class="bg-white rounded overflow-hidden">
                        <img src="https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/e6da41fa-1be4-4ce5-b89c-22be4f1f02d4/air-force-1-07-shoes-WrLlWX.png" alt="Nike Air Force 1" class="img-fluid">
                        <div class="p-3">
                            <p class="text-muted small mb-1">Nam</p>
                            <h5 class="mb-2 fw-normal">Nike Air Force 1 '07</h5>
                            <p class="fw-bold mb-2">2,929,000₫</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-6 col-md-3">
                    <div class="bg-white rounded overflow-hidden">
                        <img src="https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/b3145d0d-39d5-4e58-95b4-dd2308fa847e/dri-fit-academy-football-shorts-LrqfHz.png" alt="Nike Dri-FIT Academy" class="img-fluid">
                        <div class="p-3">
                            <p class="text-muted small mb-1">Nam</p>
                            <h5 class="mb-2 fw-normal">Nike Dri-FIT Academy</h5>
                            <p class="fw-bold mb-2">689,000₫</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-6 col-md-3">
                    <div class="bg-white rounded overflow-hidden">
                        <img src="https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/s69y0xkgkmphuhccoyc1/sportswear-club-fleece-crew-QMn86n.png" alt="Nike Sportswear Club Fleece" class="img-fluid">
                        <div class="p-3">
                            <p class="text-muted small mb-1">Nữ</p>
                            <h5 class="mb-2 fw-normal">Nike Sportswear Club Fleece</h5>
                            <p class="fw-bold mb-2">1,659,000₫</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-6 col-md-3">
                    <div class="bg-white rounded overflow-hidden">
                        <img src="https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/10b23599-7cb8-4b9b-ad7c-efda29e3c836/pegasus-40-road-running-shoes-mVJdmS.png" alt="Nike Pegasus 40" class="img-fluid">
                        <div class="p-3">
                            <p class="text-muted small mb-1">Nữ</p>
                            <h5 class="mb-2 fw-normal">Nike Pegasus 40</h5>
                            <p class="fw-bold mb-2">3,669,000₫</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Trending Now Section -->
    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0">XU HƯỚNG</h4>
                <a href="#" class="text-decoration-none text-dark">Xem Tất Cả</a>
            </div>
            
            <div class="row g-4">
                <!-- Trend Item 1 -->
                <div class="col-md-4">
                    <div class="position-relative">
                        <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/h_540,c_limit/328697fe-08cb-4cb6-99df-e4ad79ba5e4a/nike-just-do-it.jpg" class="img-fluid rounded" alt="Running Trend">
                        <div class="position-absolute bottom-0 start-0 p-4">
                            <h5 class="fw-bold text-white">CHẠY BỘ</h5>
                            <p class="text-white mb-3">Khám phá bộ sưu tập giày chạy bộ mới nhất</p>
                            <a href="#" class="btn btn-light rounded-pill px-4 py-2 fw-bold">MUA SẮM</a>
                        </div>
                    </div>
                </div>
                
                <!-- Trend Item 2 -->
                <div class="col-md-4">
                    <div class="position-relative">
                        <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/h_540,c_limit/4f37fca8-6162-4fba-a29f-7b9650d979b5/nike-just-do-it.jpg" class="img-fluid rounded" alt="Football Trend">
                        <div class="position-absolute bottom-0 start-0 p-4">
                            <h5 class="fw-bold text-white">BÓNG ĐÁ</h5>
                            <p class="text-white mb-3">Trang phục và phụ kiện bóng đá chuyên nghiệp</p>
                            <a href="#" class="btn btn-light rounded-pill px-4 py-2 fw-bold">MUA SẮM</a>
                        </div>
                    </div>
                </div>
                
                <!-- Trend Item 3 -->
                <div class="col-md-4">
                    <div class="position-relative">
                        <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/h_540,c_limit/39d9bc0c-7157-4db8-899a-5a3d63ffc564/nike-just-do-it.jpg" class="img-fluid rounded" alt="Lifestyle Trend">
                        <div class="position-absolute bottom-0 start-0 p-4">
                            <h5 class="fw-bold text-white">PHONG CÁCH</h5>
                            <p class="text-white mb-3">Thời trang đường phố cho cuộc sống hàng ngày</p>
                            <a href="#" class="btn btn-light rounded-pill px-4 py-2 fw-bold">MUA SẮM</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Large Banner -->
    <section class="py-5">
        <div class="container">
            <div class="position-relative">
                <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/w_1423,c_limit/f7519f38-3c77-4384-ac0b-7f7f60f85e50/nike-just-do-it.jpg" class="img-fluid w-100 rounded" alt="Nike Collection">
                <div class="position-absolute top-50 start-0 translate-middle-y p-5">
                    <h2 class="display-4 fw-bold text-white mb-3">BỘ SƯU TẬP MỚI</h2>
                    <p class="lead text-white mb-4">Khám phá những thiết kế mới nhất dành cho mùa này</p>
                    <a href="#" class="btn btn-light rounded-pill px-4 py-2 fw-bold">MUA NGAY</a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Featured Collections -->
    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0">BỘ SƯU TẬP NỔI BẬT</h4>
                <a href="#" class="text-decoration-none text-dark">Xem Tất Cả</a>
            </div>
            
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="position-relative">
                        <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/h_700,c_limit/c690fe44-1574-46c7-8b97-1dc40efe18b3/nike-just-do-it.jpg" alt="Summer Collection" class="img-fluid rounded">
                        <div class="position-absolute bottom-0 start-0 p-4">
                            <h3 class="fw-bold text-white mb-3">BỘ SƯU TẬP HÈ</h3>
                            <a href="#" class="btn btn-light rounded-pill px-4 py-2 fw-bold">XEM BỘ SƯU TẬP</a>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="position-relative">
                        <img src="https://static.nike.com/a/images/f_auto/dpr_1.3,cs_srgb/h_700,c_limit/c07bb7a8-2531-4f44-8dfc-2747d3e93c25/nike-just-do-it.jpg" alt="Autumn Collection" class="img-fluid rounded">
                        <div class="position-absolute bottom-0 start-0 p-4">
                            <h3 class="fw-bold text-white mb-3">BỘ SƯU TẬP THU</h3>
                            <a href="#" class="btn btn-light rounded-pill px-4 py-2 fw-bold">XEM BỘ SƯU TẬP</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Nike-style Footer -->
    <footer class="bg-dark text-white pt-5">
        <div class="container">
            <div class="row">
                <!-- First Column: Categories -->
                <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                    <h5 class="text-uppercase fw-bold mb-3 fs-6">SẢN PHẨM ĐẶC SẮC</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Giày Air Force 1</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Giày Air Max</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Giày Air Jordan 1</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Bộ sưu tập Dunk</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Blazer</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Tất cả giày</a></li>
                    </ul>
                </div>
                
                <!-- Second Column: Men's Products -->
                <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                    <h5 class="text-uppercase fw-bold mb-3 fs-6">NAM</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Giày</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Quần áo</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Phụ kiện</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Tất cả sản phẩm nam</a></li>
                    </ul>
                    
                    <h5 class="text-uppercase fw-bold mb-3 mt-4 fs-6">TRẺ EM</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Giày cho trẻ nhỏ</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Quần áo trẻ em</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Tất cả sản phẩm trẻ em</a></li>
                    </ul>
                </div>
                
                <!-- Third Column: Women's Products -->
                <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                    <h5 class="text-uppercase fw-bold mb-3 fs-6">NỮ</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Giày</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Quần áo</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Phụ kiện</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Tất cả sản phẩm nữ</a></li>
                    </ul>
                    
                    <h5 class="text-uppercase fw-bold mb-3 mt-4 fs-6">GIỚI THIỆU</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Tin tức</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Nghề nghiệp</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Nhà đầu tư</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Bền vững</a></li>
                    </ul>
                </div>
                
                <!-- Fourth Column: Help & Social Media -->
                <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                    <h5 class="text-uppercase fw-bold mb-3 fs-6">TRỢ GIÚP</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Tình trạng đơn hàng</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Vận chuyển & giao hàng</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Trả hàng</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Phương thức thanh toán</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Liên hệ</a></li>
                    </ul>
                    
                    <div class="mt-4">
                        <h5 class="text-uppercase fw-bold mb-3 fs-6">KẾT NỐI VỚI CHÚNG TÔI</h5>
                        <div class="d-flex">
                            <a href="#" class="me-3 text-white fs-5"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="me-3 text-white fs-5"><i class="fab fa-instagram"></i></a>
                            <a href="#" class="me-3 text-white fs-5"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="me-3 text-white fs-5"><i class="fab fa-youtube"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Copyright and Location -->
            <div class="row mt-5 pt-4 pb-3 border-top border-secondary">
                <div class="col-lg-8 col-md-6 small text-white-50">
                    <div class="d-flex flex-wrap mb-3">
                        <a href="#" class="me-4 text-white-50 text-decoration-none mb-2">Hướng dẫn</a>
                        <a href="#" class="me-4 text-white-50 text-decoration-none mb-2">Điều khoản sử dụng</a>
                        <a href="#" class="me-4 text-white-50 text-decoration-none mb-2">Bán hàng & Hoàn tiền</a>
                        <a href="#" class="me-4 text-white-50 text-decoration-none mb-2">Chính sách quyền riêng tư</a>
                        <a href="#" class="text-white-50 text-decoration-none mb-2">Cài đặt cookie</a>
                    </div>
                    <p>&copy; 2023 NICE, Inc. All Rights Reserved</p>
                </div>
                <div class="col-lg-4 col-md-6 text-md-end small text-white-50">
                    <p class="mb-0">Việt Nam</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- AOS Animation -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        // Initialize AOS animations
        AOS.init();
        
        // Shop by Icons carousel navigation
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.querySelector('.shop-icons-container');
            const prevBtn = document.querySelector('.nav-arrow.prev');
            const nextBtn = document.querySelector('.nav-arrow.next');
            
            if (container && prevBtn && nextBtn) {
                prevBtn.addEventListener('click', function() {
                    container.scrollBy({ left: -250, behavior: 'smooth' });
                });
                
                nextBtn.addEventListener('click', function() {
                    container.scrollBy({ left: 250, behavior: 'smooth' });
                });
            }
        });
    </script>
</body>
</html>
