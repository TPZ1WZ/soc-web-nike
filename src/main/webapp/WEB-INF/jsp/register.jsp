<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký | NICE Store</title>
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
        
        .register-container {
            background-color: white;
            padding: 2.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 700px;
        }
        
        .logo {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        
        .logo img {
            height: 60px;
        }
        
        .register-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .register-subtitle {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--text-color);
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
        
        .error-message {
            color: var(--error-color);
            font-size: 0.85rem;
            margin-top: 0.25rem;
        }
        
        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.95rem;
        }
        
        .login-link a {
            color: var(--primary-color);
            font-weight: 500;
            text-decoration: none;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .auth-footer {
            text-align: center;
            font-size: 0.8rem;
            color: #999;
            padding: 1.5rem;
        }
        
        .social-btn-icon {
            margin-right: 0.5rem;
        }
        
        @media (max-width: 576px) {
            .register-container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="register-container">
            <div class="logo">
                <img src="<c:url value='/img/nike-logo.png'/>" alt="NICE Store">
            </div>
            
            <h1 class="register-title">TẠO TÀI KHOẢN</h1>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i> ${success}
                </div>
            </c:if>
        
        <form method="post" action="<c:url value='/register'/>" class="needs-validation" novalidate>
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="firstName" class="form-label">Họ</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" class="form-control" id="firstName" name="firstName" value="${registerRequest.firstName}" required>
                        </div>
                        <c:if test="${not empty org.springframework.validation.BindingResult.registerRequest.getFieldError('firstName')}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle me-1"></i>
                                ${org.springframework.validation.BindingResult.registerRequest.getFieldError('firstName').defaultMessage}
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="lastName" class="form-label">Tên</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="text" class="form-control" id="lastName" name="lastName" value="${registerRequest.lastName}" required>
                        </div>
                        <c:if test="${not empty org.springframework.validation.BindingResult.registerRequest.getFieldError('lastName')}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle me-1"></i>
                                ${org.springframework.validation.BindingResult.registerRequest.getFieldError('lastName').defaultMessage}
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="email" class="form-label">Email</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" value="${registerRequest.email}" required>
                        </div>
                        <c:if test="${not empty org.springframework.validation.BindingResult.registerRequest.getFieldError('email')}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle me-1"></i>
                                ${org.springframework.validation.BindingResult.registerRequest.getFieldError('email').defaultMessage}
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-phone"></i></span>
                            <input type="text" class="form-control" id="phone" name="phone" value="${registerRequest.phone}" placeholder="Ví dụ: 0912345678" required>
                        </div>
                        <c:if test="${not empty org.springframework.validation.BindingResult.registerRequest.getFieldError('phone')}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle me-1"></i>
                                ${org.springframework.validation.BindingResult.registerRequest.getFieldError('phone').defaultMessage}
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <c:if test="${not empty org.springframework.validation.BindingResult.registerRequest.getFieldError('password')}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle me-1"></i>
                                ${org.springframework.validation.BindingResult.registerRequest.getFieldError('password').defaultMessage}
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="passwordConfirm" class="form-label">Xác nhận mật khẩu</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <input type="password" class="form-control" id="passwordConfirm" name="passwordConfirm" required>
                        </div>
                        <c:if test="${not empty org.springframework.validation.BindingResult.registerRequest.getFieldError('passwordConfirm')}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle me-1"></i>
                                ${org.springframework.validation.BindingResult.registerRequest.getFieldError('passwordConfirm').defaultMessage}
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="form-group mt-3">
                <label for="address" class="form-label">Địa chỉ</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-home"></i></span>
                    <input type="text" class="form-control" id="address" name="address" value="${registerRequest.address}" required>
                </div>
                <c:if test="${not empty org.springframework.validation.BindingResult.registerRequest.getFieldError('address')}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle me-1"></i>
                        ${org.springframework.validation.BindingResult.registerRequest.getFieldError('address').defaultMessage}
                    </div>
                </c:if>
            </div>
            
            <div class="form-group mt-3">
                <label class="form-label d-block">Giới tính</label>
                <div class="d-flex gap-4">
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="gender" id="genderMale" value="Nam" 
                               ${registerRequest.gender == 'Nam' ? 'checked' : ''} required>
                        <label class="form-check-label" for="genderMale">Nam</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="gender" id="genderFemale" value="Nữ"
                               ${registerRequest.gender == 'Nữ' ? 'checked' : ''}>
                        <label class="form-check-label" for="genderFemale">Nữ</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="gender" id="genderOther" value="Khác"
                               ${registerRequest.gender == 'Khác' ? 'checked' : ''}>
                        <label class="form-check-label" for="genderOther">Khác</label>
                    </div>
                </div>
                <c:if test="${not empty org.springframework.validation.BindingResult.registerRequest.getFieldError('gender')}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle me-1"></i>
                        ${org.springframework.validation.BindingResult.registerRequest.getFieldError('gender').defaultMessage}
                    </div>
                </c:if>
            </div>
            
            <div class="form-group mt-4">
                <button type="submit" class="btn btn-primary">ĐĂNG KÝ</button>
            </div>

            <div class="separator">HOẶC</div>
            
            <a href="/oauth2/authorization/google" class="btn btn-google">
                <span class="social-btn-icon"><i class="fab fa-google"></i></span>Tiếp tục với Google
            </a>
            
            <a href="/oauth2/authorization/facebook" class="btn btn-facebook">
                <span class="social-btn-icon"><i class="fab fa-facebook-f"></i></span>Tiếp tục với Facebook
            </a>
            
            <div class="login-link">
                Đã có tài khoản? <a href="<c:url value='/login'/>">Đăng nhập ngay</a>
            </div>
        </form>
        </div>
    </div>
    
    <div class="auth-footer">
        &copy; 2025 NICE Store. Đã đăng ký bản quyền.
    </div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Form validation script
    (function () {
        'use strict'
        
        // Fetch all the forms we want to apply custom validation styles to
        const forms = document.querySelectorAll('.needs-validation')
        
        // Loop over them and prevent submission
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                
                form.classList.add('was-validated')
            }, false)
        })
    })()
</script>
</body>
</html>
