# 🎫 Hướng Dẫn Áp Dụng Mã Giảm Giá Vào Sản Phẩm

## 📋 Tổng quan

Hệ thống mã giảm giá đã được tích hợp hoàn chỉnh vào website Nike Store với các tính năng:

### ✨ Tính năng đã hoàn thành

#### 🔧 Backend APIs (Đã có sẵn)
- ✅ **Kiểm tra mã giảm giá**: `GET /api/public/promotions/check-coupon/{code}?orderAmount={amount}`
- ✅ **Áp dụng mã giảm giá**: `POST /api/public/promotions/apply-coupon`
- ✅ **Tìm mã tốt nhất**: `GET /api/promotions/best-coupon?orderAmount={amount}`
- ✅ **Gợi ý mã phù hợp**: `GET /api/promotions/applicable-coupons?orderAmount={amount}`
- ✅ **So sánh nhiều mã**: `POST /api/public/promotions/compare`
- ✅ **Tính toán giảm giá**: `GET /api/coupons/calculate/{code}?orderAmount={amount}`

#### 🎨 Frontend Components (Mới tạo)
- ✅ **Giao diện áp dụng mã giảm giá** trong giỏ hàng
- ✅ **Giao diện áp dụng mã giảm giá** trong checkout
- ✅ **Trang demo** để test các mã giảm giá
- ✅ **CSS hiện đại** cho tính năng coupon
- ✅ **JavaScript tương tác** với APIs

## 🚀 Cách sử dụng

### 1. 🛒 Trong Giỏ Hàng (`/cart`)

**Tính năng:**
- **Nhập mã thủ công**: Người dùng có thể nhập mã giảm giá vào ô input
- **Mã gợi ý**: Hệ thống tự động gợi ý các mã phù hợp với tổng tiền
- **Mã tốt nhất**: Banner hiển thị mã giảm giá tốt nhất có thể áp dụng
- **Real-time calculation**: Tính toán và hiển thị giá sau giảm ngay lập tức
- **Remove coupon**: Xóa mã giảm giá đã áp dụng

**Code tích hợp:**
```html
<!-- Đã thêm vào src/main/resources/templates/cart.html -->
<div class="coupon-section">
    <h5><i class="fa fa-ticket"></i> Mã giảm giá</h5>
    <!-- Form nhập mã + suggestions + applied coupon display -->
</div>
```

### 2. 💳 Trong Checkout (`/orders/checkout`)

**Tính năng:**
- **Tương tự giỏ hàng** nhưng trong context thanh toán
- **Tính toán cuối cùng**: Áp dụng mã giảm giá vào tổng tiền thanh toán
- **Gửi thông tin coupon**: Khi đặt hàng, thông tin mã giảm giá được gửi kèm

**Code tích hợp:**
```html
<!-- Đã thêm vào src/main/resources/templates/checkout.html -->
<div class="price-breakdown">
    <div class="price-row discount">
        <span>Giảm giá (<span id="appliedDiscountCode"></span>):</span>
        <span id="discountAmount">- 0 ₫</span>
    </div>
</div>
```

### 3. 🧪 Trang Demo (`/demo/coupons`)

**Tính năng:**
- **Test tất cả mã giảm giá**: Hiển thị tất cả mã có sẵn trong hệ thống
- **Mô phỏng đơn hàng**: Nhập số tiền để test với các mã khác nhau
- **So sánh kết quả**: Xem mã nào tiết kiệm nhiều nhất
- **API Documentation**: Hướng dẫn sử dụng các API endpoints

## 📊 Mã Giảm Giá Có Sẵn

Hệ thống đã có các mã giảm giá mẫu:

### 🎁 Mã giảm giá phổ biến
```sql
-- WELCOME10: Giảm 10% cho khách hàng mới
-- SAVE50K: Giảm 50,000₫ cho đơn từ 500,000₫  
-- FLASH20: Flash sale 20% tối đa 100,000₫
-- VIP15: VIP 15% cho thành viên đặc biệt
```

### 💰 Cách hoạt động

1. **Mã phần trăm (PERCENTAGE)**:
   ```
   Giảm giá = (Số tiền đơn hàng × Phần trăm) / 100
   Nếu có giảm tối đa: min(Giảm giá, Giảm tối đa)
   ```

2. **Mã số tiền cố định (FIXED_AMOUNT)**:
   ```
   Giảm giá = Số tiền cố định
   Nếu > Tổng đơn hàng: Giảm = Tổng đơn hàng
   ```

3. **Điều kiện áp dụng**:
   - Đơn hàng tối thiểu (minOrderAmount)
   - Thời gian hiệu lực (startDate, endDate)
   - Số lần sử dụng (usageLimit)
   - Trạng thái active

## 🎯 Quy trình áp dụng mã giảm giá

### Bước 1: Khách hàng nhập mã
```javascript
// Frontend call API kiểm tra
fetch('/api/public/promotions/check-coupon/WELCOME10?orderAmount=500000')
```

### Bước 2: Hệ thống validate
```java
// Backend validate mã giảm giá
@Service
public class CouponService {
    public boolean isValidCoupon(String code) {
        // Kiểm tra mã tồn tại
        // Kiểm tra thời gian hiệu lực
        // Kiểm tra số lần sử dụng
        // Kiểm tra trạng thái active
    }
}
```

### Bước 3: Tính toán giảm giá
```java
@Service 
public class CouponService {
    public Double calculateDiscount(String code, Double orderAmount) {
        // Áp dụng logic giảm giá theo loại
        // Kiểm tra điều kiện đơn hàng tối thiểu
        // Áp dụng giảm tối đa nếu có
    }
}
```

### Bước 4: Hiển thị kết quả
```javascript
// Frontend update UI
const updatePricing = (couponData) => {
    discountAmount.textContent = `-${formatCurrency(couponData.discountAmount)}`;
    finalTotal.textContent = formatCurrency(couponData.finalAmount);
};
```

### Bước 5: Áp dụng vào đơn hàng
```javascript
// Khi checkout, gửi thông tin coupon
const payload = {
    totalAmount: finalAmount,
    couponCode: currentCoupon ? currentCoupon.couponCode : null,
    discountAmount: currentCoupon ? currentCoupon.discountAmount : 0
};
```

## 🔧 Cấu hình và Customization

### 1. Thêm mã giảm giá mới

**Via Admin Panel**: `/admin/coupons/create`
```
- Mã code: SUMMER2024
- Tên: Ưu đãi mùa hè
- Loại giảm: PERCENTAGE
- Giá trị: 15
- Đơn tối thiểu: 300000
- Giảm tối đa: 150000
```

**Via API**: `POST /api/coupons`
```json
{
    "code": "SUMMER2024",
    "name": "Ưu đãi mùa hè",
    "discountType": "PERCENTAGE",
    "discountValue": 15,
    "minOrderAmount": 300000,
    "maxDiscountAmount": 150000,
    "startDate": "2024-06-01T00:00:00",
    "endDate": "2024-08-31T23:59:59"
}
```

### 2. Customize giao diện

**CSS Variables** trong `/css/coupon-apply.css`:
```css
:root {
    --coupon-primary: #667eea;      /* Màu chủ đạo */
    --coupon-success: #28a745;      /* Màu thành công */
    --coupon-border-radius: 12px;   /* Bo góc */
}
```

**JavaScript Configuration**:
```javascript
const COUPON_CONFIG = {
    maxSuggestions: 4,           // Số mã gợi ý tối đa
    autoHideResultAfter: 3000,   // Tự động ẩn thông báo sau 3s
    enableBestCouponBanner: true // Hiển thị banner mã tốt nhất
};
```

## 📱 Responsive Design

Giao diện đã được tối ưu cho mọi thiết bị:

```css
@media (max-width: 768px) {
    .coupon-input-group {
        flex-direction: column;  /* Stack vertical trên mobile */
    }
    
    .btn-apply-coupon {
        width: 100%;            /* Full width button */
    }
}
```

## 🔒 Security & Validation

### Frontend Validation
- Kiểm tra mã không rỗng
- Validate số tiền đơn hàng > 0
- Rate limiting cho API calls

### Backend Security
- CSRF Protection với Spring Security
- Input sanitization
- SQL Injection prevention với JPA
- Business logic validation

## 🚀 Performance Optimization

### 1. API Caching
```java
@Cacheable("coupons")
public List<CouponDto> getActiveCoupons() {
    // Cache kết quả cho performance
}
```

### 2. Frontend Optimization
- Debounce user input
- Lazy loading cho suggestions
- Minimize API calls
- Efficient DOM updates

## 📈 Analytics & Tracking

### Usage Tracking
```java
@Service
public class PromotionService {
    public void recordCouponUsage(Long couponId) {
        // Track số lần sử dụng mã
        // Analytics data cho admin
    }
}
```

### Metrics Available
- Số lần áp dụng mỗi mã
- Tổng tiền tiết kiệm
- Conversion rate
- Popular coupons

## 🎮 Testing & Demo

### 1. Unit Test
```bash
# Test coupon calculation logic
mvn test -Dtest=CouponServiceTest

# Test API endpoints  
mvn test -Dtest=PromotionControllerTest
```

### 2. Manual Testing
1. Truy cập `/demo/coupons` để test interactive
2. Test với các scenarios:
   - Đơn hàng dưới/trên minimum
   - Mã hết hạn
   - Mã không tồn tại
   - Multiple coupons

### 3. Test Data
```sql
-- Mã test có sẵn trong database
INSERT INTO coupons (code, name, discount_type, discount_value, min_order_amount) 
VALUES 
('TEST10', 'Test 10%', 'PERCENTAGE', 10, 100000),
('TEST50K', 'Test 50K', 'FIXED_AMOUNT', 50000, 200000);
```

## 🔄 Future Enhancements

### Planned Features
- [ ] **Multiple coupons**: Áp dụng nhiều mã cùng lúc
- [ ] **Automatic application**: Tự động áp dụng mã tốt nhất
- [ ] **Coupon sharing**: Chia sẻ mã qua social media
- [ ] **Loyalty integration**: Tích hợp với hệ thống tích điểm
- [ ] **A/B testing**: Test hiệu quả các chiến dịch coupon

### Architecture Improvements
- [ ] **Microservices**: Tách promotion service
- [ ] **Event Sourcing**: Track coupon usage events
- [ ] **Real-time notifications**: WebSocket cho flash sales
- [ ] **Machine Learning**: AI recommendation engine

## 📞 Support & Troubleshooting

### Common Issues

1. **Mã không áp dụng được**
   - Kiểm tra điều kiện đơn hàng tối thiểu
   - Verify thời gian hiệu lực
   - Check số lần sử dụng còn lại

2. **API lỗi 404**
   - Kiểm tra endpoint URLs
   - Verify controller mapping
   - Check Spring Security config

3. **Frontend không load**
   - Check console for JavaScript errors
   - Verify CSS file paths
   - Ensure APIs are accessible

### Debug Tools
```javascript
// Enable debug mode
localStorage.setItem('coupon-debug', 'true');

// Log all API calls
const originalFetch = fetch;
window.fetch = function(...args) {
    console.log('Coupon API Call:', args);
    return originalFetch.apply(this, arguments);
};
```

---

## 🎉 Kết luận

Hệ thống mã giảm giá đã được tích hợp hoàn chỉnh với:

✅ **Backend APIs đầy đủ** cho mọi tính năng coupon
✅ **Frontend hiện đại** với UX/UI tốt  
✅ **Responsive design** cho mọi thiết bị
✅ **Security & performance** được tối ưu
✅ **Testing & demo tools** để validate

**Ready to use!** 🚀