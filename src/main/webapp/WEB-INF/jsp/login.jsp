<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập | NICE Store</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        :root {
            --primary-color: #111111;
            --text-color: #757575;
            --error-color: #dc3545;
            --success-color: #198754;
            --focus-color: #111111;
        }
        
        body {
            font-family: 'Helvetica', 'Arial', sans-serif;
            background-color: #f5f5f5;
            color: var(--text-color);
            line-height: 1.5;
            letter-spacing: -0.01em;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        
        .login-container {
            background-color: white;
            padding: 2.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 450px;
        }
        
        .logo {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        
        .logo img {
            height: 60px;
        }
        
        .login-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 1.25rem;
        }
        
        .form-label {
            font-weight: 500;
            font-size: 0.95rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--focus-color);
            box-shadow: 0 0 0 2px rgba(17, 17, 17, 0.1);
            outline: none;
        }
        
        .btn {
            display: inline-block;
            font-weight: 600;
            text-align: center;
            padding: 0.75rem 1.25rem;
            border-radius: 30px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            width: 100%;
            margin-bottom: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #333;
            transform: translateY(-2px);
        }
        
        .btn-google {
            background-color: white;
            color: #333;
            border: 1px solid #ddd;
        }
        
        .btn-google:hover {
            background-color: #f8f9fa;
        }
        
        .btn-facebook {
            background-color: #4267B2;
            color: white;
        }
        
        .btn-facebook:hover {
            background-color: #385898;
        }
        
        .separator {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 1.5rem 0;
            color: #999;
            font-size: 0.9rem;
        }
        
        .separator::before, .separator::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .separator::before {
            margin-right: 1rem;
        }
        
        .separator::after {
            margin-left: 1rem;
        }
        
        .alert {
            padding: 0.75rem 1rem;
            margin-bottom: 1.5rem;
            border-radius: 6px;
            font-size: 0.9rem;
        }
        
        .alert-danger {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--error-color);
        }
        
        .alert-success {
            background-color: rgba(25, 135, 84, 0.1);
            color: var(--success-color);
        }
        
        .register-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.95rem;
        }
        
        .register-link a {
            color: var(--primary-color);
            font-weight: 500;
            text-decoration: none;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        .auth-footer {
            text-align: center;
            font-size: 0.8rem;
            color: #999;
            padding: 1.5rem;
        }
        
        .forgot-password {
            text-align: right;
            font-size: 0.85rem;
            margin-bottom: 1.25rem;
        }
        
        .forgot-password a {
            color: var(--text-color);
            text-decoration: none;
        }
        
        .forgot-password a:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }
        
        .social-btn-icon {
            margin-right: 0.5rem;
        }
        
        @media (max-width: 576px) {
            .login-container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="login-container">
            <div class="logo">
                <img src="<c:url value='/img/nike-logo.png'/>" alt="NICE Store">
            </div>
            
            <h1 class="login-title">ĐĂNG NHẬP VÀO TÀI KHOẢN CỦA BẠN</h1>
            
            <c:if test="${param.error != null}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>Email hoặc mật khẩu không đúng!
                </div>
            </c:if>
            <c:if test="${param.logout != null}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>Bạn đã đăng xuất thành công!
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                </div>
            </c:if>
            
            <form method="post" action="<c:url value='/doLogin'/>">
                <div class="form-group">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        <input type="email" id="email" name="email" class="form-control" placeholder="Nhập email của bạn" required />
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu của bạn" required />
                    </div>
                </div>
                
                <div class="forgot-password">
                    <a href="#">Quên mật khẩu?</a>
                </div>
                
                <button type="submit" class="btn btn-primary">ĐĂNG NHẬP</button>
            </form>
            
            <div class="separator">HOẶC</div>
            
            <a href="/oauth2/authorization/google" class="btn btn-google">
                <span class="social-btn-icon"><i class="fab fa-google"></i></span>Tiếp tục với Google
            </a>
            
            <a href="/oauth2/authorization/facebook" class="btn btn-facebook">
                <span class="social-btn-icon"><i class="fab fa-facebook-f"></i></span>Tiếp tục với Facebook
            </a>
            
            <div class="register-link">
                Chưa có tài khoản? <a href="<c:url value='/register'/>">Đăng ký ngay</a>
            </div>
        </div>
    </div>
    
    <div class="auth-footer">
        &copy; 2025 NICE Store. Đã đăng ký bản quyền.
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>