# 🎫 Hệ Thống Quản Lý Mã Giảm Giá Hiện Đại

## 📋 Tổng quan

Hệ thống quản lý mã giảm giá hiện đại được thiết kế với giao diện tương tự các trang web thương mại điện tử hàng đầu, tích hợp đầy đủ các tính năng CRUD và có giao diện quản trị hiện đại.

## ✨ Tính năng chính

### 🎨 Giao diện hiện đại
- **Thiết kế hiện đại**: Giao diện đơn giản, sạch sẽ với design system nhất quán
- **Responsive Design**: Tối ưu cho mọi thiết bị (desktop, tablet, mobile)
- **Dark Mode Ready**: Hỗ trợ chế độ tối với CSS custom properties
- **Typography hiện đại**: Sử dụng font Inter cho trải nghiệm đọc tốt nhất
- **Icons chuyên nghiệp**: Font Awesome 6.4.0 cho biểu tượng chất lượng cao

### 🛠 Quản lý mã giảm giá
- **Tạo mã giảm giá**: Form tạo mã với xem trước real-time
- **Danh sách mã giảm giá**: Bảng hiển thị với phân trang và tìm kiếm
- **Chỉnh sửa/Xóa**: Quản lý trạng thái và xóa mã giảm giá
- **Thống kê**: Dashboard với các metrics quan trọng
- **Tìm kiếm**: Tìm kiếm theo mã, tên hoặc mô tả

### 💰 Loại mã giảm giá
- **Phần trăm (%)**: Giảm theo tỷ lệ phần trăm
- **Số tiền cố định (₫)**: Giảm số tiền cố định
- **Điều kiện linh hoạt**: Đơn hàng tối thiểu, giảm tối đa
- **Giới hạn sử dụng**: Số lần sử dụng tổng và mỗi khách hàng
- **Thời gian hiệu lực**: Ngày bắt đầu và kết thúc

## 🏗 Kiến trúc hệ thống

### Backend
```
src/main/java/com/proj/webprojrct/promotion/
├── entity/
│   └── Coupon.java               # Entity chính
├── dto/
│   ├── request/
│   │   └── CouponCreateRequest.java
│   └── response/
│       └── CouponResponse.java
├── repository/
│   └── CouponRepository.java     # JPA Repository
├── service/
│   └── CouponService.java        # Business logic
└── controller/
    └── AdminCouponController.java # REST Controller
```

### Frontend
```
src/main/resources/
├── static/css/
│   └── admin-modern.css          # CSS hiện đại
└── templates/admin/
    ├── coupons-modern.html       # Danh sách mã giảm giá
    └── coupon-form-modern.html   # Form tạo/sửa mã
```

### Database
```sql
-- Bảng coupons với đầy đủ ràng buộc
CREATE TABLE coupons (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type VARCHAR(20) NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    min_order_amount DECIMAL(10,2),
    max_discount_amount DECIMAL(10,2),
    usage_limit INTEGER,
    usage_limit_per_user INTEGER,
    used_count INTEGER DEFAULT 0,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🎯 Đặc điểm thiết kế

### CSS Modern Design System
```css
:root {
    /* Color Palette */
    --primary-color: #4facfe;
    --primary-color-dark: #2196f3;
    --success-color: #28a745;
    --warning-color: #ffc107;
    --danger-color: #dc3545;
    --info-color: #17a2b8;
    
    /* Typography */
    --font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
    
    /* Spacing & Layout */
    --border-radius: 8px;
    --border-radius-lg: 12px;
    --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
    --shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.15);
}
```

### Component Library
- **Modern Cards**: Thiết kế card với shadow và border radius
- **Advanced Buttons**: Multiple variants với hover effects
- **Smart Forms**: Validation và real-time preview
- **Data Tables**: Responsive table với action buttons
- **Statistics Cards**: Dashboard metrics với icons
- **Loading States**: Smooth loading animations

## 📊 Dữ liệu mẫu

Hệ thống đã được populate với dữ liệu mẫu thực tế:

```sql
-- WELCOME10: Mã chào mừng 10%
-- SAVE50K: Giảm 50,000₫ cho đơn từ 500,000₫  
-- FLASH20: Flash sale 20% tối đa 100,000₫
-- VIP15: VIP 15% cho thành viên đặc biệt
```

## 🚀 URL và Navigation

### Admin Dashboard
- **Danh sách mã giảm giá**: `/admin/coupons`
- **Tạo mã mới**: `/admin/coupons/create`
- **Chỉnh sửa**: `/admin/coupons/{id}/edit`
- **API endpoints**: 
  - `POST /admin/coupons/{id}/toggle-status`
  - `POST /admin/coupons/{id}/delete`

### Tính năng JavaScript
- **Real-time Preview**: Xem trước mã giảm giá khi nhập form
- **Auto-validation**: Validate form theo real-time
- **AJAX Operations**: Toggle status và delete không reload page
- **Search Debouncing**: Tìm kiếm thông minh với độ trễ
- **Loading States**: Loading overlay cho UX tốt hơn

## 🔧 Cài đặt và Chạy

### Prerequisites
- Java 17+
- PostgreSQL 16
- Maven 3.8+
- Docker (cho database)

### Khởi chạy
```bash
# Khởi động database
docker-compose up -d

# Chạy ứng dụng
mvn spring-boot:run

# Truy cập admin
http://localhost:8080/admin/coupons
```

## 🎨 Tùy chỉnh giao diện

### CSS Variables
Dễ dàng tùy chỉnh theme bằng cách thay đổi CSS variables:

```css
:root {
    --primary-color: #your-brand-color;
    --font-family: 'Your-Font', sans-serif;
    --border-radius: 12px; /* Rounded corners */
}
```

### Responsive Breakpoints
```css
/* Mobile First Approach */
@media (min-width: 768px) { /* Tablet */ }
@media (min-width: 1024px) { /* Desktop */ }
@media (min-width: 1200px) { /* Large Desktop */ }
```

## 📱 Mobile Experience

- **Touch-friendly**: Buttons và inputs được tối ưu cho touch
- **Swipe Gestures**: Hỗ trợ swipe trên mobile table
- **Responsive Grid**: Layout tự động adjust theo screen size
- **Fast Loading**: Optimized CSS và lazy loading

## 🔍 SEO và Accessibility

- **Semantic HTML**: Sử dụng đúng semantic tags
- **ARIA Labels**: Accessibility labels cho screen readers
- **Keyboard Navigation**: Đầy đủ keyboard shortcuts
- **Color Contrast**: Đảm bảo contrast ratio chuẩn WCAG

## 🚀 Performance

- **CSS Optimization**: Minified và optimized CSS
- **Font Loading**: Preload critical fonts
- **Image Optimization**: Responsive images với lazy loading
- **JavaScript**: Modern ES6+ với polyfills

## 🛡 Security

- **CSRF Protection**: Spring Security integration
- **Input Validation**: Server-side và client-side validation
- **SQL Injection Prevention**: JPA/Hibernate protection
- **XSS Protection**: Thymeleaf auto-escaping

## 📈 Metrics và Analytics

### Dashboard Statistics
- Tổng số mã giảm giá
- Mã đang hoạt động
- Mã còn hiệu lực  
- Tỷ lệ hiệu lực

### Usage Tracking
- Số lần sử dụng mỗi mã
- Tracking theo thời gian
- Revenue impact analysis

## 🔄 Future Enhancements

- [ ] Bulk operations (create/delete multiple coupons)
- [ ] Advanced filtering (by date range, type, status)
- [ ] Export functionality (Excel, CSV, PDF)
- [ ] Email integration (send coupons to customers)
- [ ] A/B testing for coupon effectiveness
- [ ] Integration với payment gateways
- [ ] Real-time notifications
- [ ] Advanced analytics dashboard

## 👨‍💻 Developer Notes

### Code Structure
- **Clean Architecture**: Separation of concerns
- **SOLID Principles**: Maintainable và extensible code
- **Design Patterns**: Repository, Service, DTO patterns
- **Error Handling**: Comprehensive exception handling

### Testing
- Unit tests cho service layer
- Integration tests cho controllers
- Frontend testing với Jest
- E2E testing với Selenium

---

## 📞 Support

Để được hỗ trợ hoặc góp ý, vui lòng tạo issue trên repository hoặc liên hệ team development.

**Happy Coding! 🎉**