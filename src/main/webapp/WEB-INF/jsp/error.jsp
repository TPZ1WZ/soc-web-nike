<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lỗi - NICESTORE</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
        }
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #e74c3c;
        }
        .home-link {
            margin-top: 20px;
            display: inline-block;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Đã xảy ra lỗi</h1>
        
        <p>${errorMessage != null ? errorMessage : 'Đã xảy ra lỗi khi xử lý yêu cầu của bạn.'}</p>
        
        <% if(request.getAttribute("statusCode") != null) { %>
            <p>Mã lỗi: ${statusCode}</p>
        <% } %>
        
        <a href="/" class="home-link">Quay lại trang chủ</a>
    </div>
</body>
</html>