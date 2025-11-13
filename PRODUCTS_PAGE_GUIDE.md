# Hướng dẫn sử dụng trang Products - Tương tự Nike

## Tổng quan

Đã thiết kế và triển khai hoàn chỉnh trang danh sách sản phẩm tương tự như Nike với các tính năng:

- **Giao diện responsive** tương tự Nike.com
- **Bộ lọc nâng cao** (tìm kiếm, danh mục, giá, thương hiệu)
- **Phân trang** với điều hướng
- **Sắp xếp** theo nhiều tiêu chí
- **API REST** đầy đủ cho frontend

## Cấu trúc Files

### Frontend
- `templates/products.html` - Giao diện chính
- `css/products.css` - Styles tương tự Nike
- `js/products.js` - JavaScript xử lý filters và pagination

### Backend
- `ProductController.java` - REST API endpoints
- `ProductViewController.java` - Controllers cho view
- `ProductService.java` - Business logic
- `ProductRepository.java` - Database queries
- `ProductFilterDto.java` - DTO cho filters
- `ProductPageDto.java` - DTO cho pagination

## API Endpoints

### 1. Lấy sản phẩm với bộ lọc (có phân trang)
```
GET /api/v1/products/filter
```

**Parameters:**
- `name` (string) - Tìm theo tên sản phẩm
- `color` (string) - Lọc theo màu sắc
- `productSize` (string) - Lọc theo kích thước
- `minPrice` (double) - Giá tối thiểu
- `maxPrice` (double) - Giá tối đa
- `minStock` (integer) - Số lượng tồn kho tối thiểu
- `categoryId` (long) - ID danh mục
- `categoryIds` (array) - Danh sách ID danh mục
- `sortBy` (string) - Trường sắp xếp (name, price, createdAt, stock)
- `sortDirection` (string) - Hướng sắp xếp (ASC, DESC)
- `page` (integer) - Trang hiện tại (bắt đầu từ 0)
- `pageSize` (integer) - Số sản phẩm mỗi trang

**Response:**
```json
{
  "content": [
    {
      "id": 1,
      "name": "Nike Air Max 270",
      "price": 3200000,
      "imageUrl": "..."
    }
  ],
  "page": 0,
  "size": 20,
  "totalElements": 150,
  "totalPages": 8,
  "first": true,
  "last": false,
  "hasNext": true,
  "hasPrevious": false
}
```

### 2. Lấy sản phẩm nổi bật
```
GET /api/v1/products/featured?limit=8
```

### 3. Lấy danh sách thương hiệu
```
GET /api/v1/products/brands
```

### 4. Lấy danh sách danh mục
```
GET /api/v1/products/categories
```

### 5. Gợi ý tìm kiếm
```
GET /api/v1/products/suggestions?query=nike&limit=5
```

## Cách truy cập

### URL Routes
- `/products` - Trang danh sách sản phẩm chính
- `/men/shoes` - Giày nam
- `/women/shoes` - Giày nữ
- `/products/{id}` - Chi tiết sản phẩm

### Query Parameters
Có thể truyền parameters để pre-filter:
- `/products?category=shoes&gender=men`

## Tính năng chính

### 1. Bộ lọc (Sidebar)
- **Tìm kiếm:** Input text với debounce 300ms
- **Danh mục:** Checkbox multiple selection
- **Giới tính:** Radio buttons (Men/Women/Unisex)
- **Giá:** Các khoảng giá định sẵn
- **Thương hiệu:** Checkbox multiple selection
- **Sale & Offers:** Checkbox cho sản phẩm giảm giá

### 2. Sắp xếp
- Featured (mặc định)
- Newest (mới nhất)
- Price: High-Low (giá giảm dần)
- Price: Low-High (giá tăng dần)

### 3. Hiển thị sản phẩm
- **Grid layout** responsive
- **Product cards** với hover effects
- **Quick actions:** Quick view, Add to wishlist
- **Product badges:** "Just In", "Best Seller", etc.

### 4. Phân trang
- **Pagination controls** với Previous/Next
- **Page numbers** với ellipsis (...)
- **Info display:** "Showing 1-20 of 150 results"
- **Smooth scrolling** khi chuyển trang

### 5. Responsive Design
- **Mobile-first** approach
- **Collapsible filters** trên mobile
- **Adaptive grid** layout
- **Touch-friendly** controls

## JavaScript Features

### ProductsPage Class
```javascript
// Khởi tạo
const productsPage = new ProductsPage();

// Methods chính
- loadProducts() // Tải sản phẩm từ API
- applyFilters() // Áp dụng bộ lọc
- goToPage(page) // Chuyển trang
- clearAllFilters() // Xóa tất cả filters
```

### Event Handling
- Filter changes → Auto reload products
- Search input → Debounced API call
- Sort selection → Reload with new sort
- Pagination clicks → Navigate to page

## Styling (Nike-inspired)

### Color Scheme
```css
--nike-black: #111111
--nike-white: #FFFFFF
--nike-gray: #757575
--nike-light-gray: #F5F5F5
--nike-orange: #FA5400
```

### Typography
- Font: Inter (similar to Nike's Helvetica)
- Weights: 400, 500, 600, 700, 800

### Layout
- **Grid system** cho products
- **Sticky sidebar** cho filters
- **Fixed header** khi scroll
- **Card-based** design cho products

## Backend Logic

### ProductService
- **Filtering logic** với JPA Criteria API
- **Pagination** với Spring Data
- **Sorting** với multiple fields
- **Error handling** với fallback data

### ProductRepository
- **Custom queries** với @Query annotation
- **Dynamic filtering** với parameters
- **Performance optimization** với indexed fields

## Cách mở rộng

### 1. Thêm filters mới
1. Thêm field vào `ProductFilterDto`
2. Cập nhật query trong `ProductRepository`
3. Thêm UI controls trong `products.html`
4. Cập nhật JavaScript logic

### 2. Thêm sort options
1. Cập nhật `getSortParam()` trong JS
2. Thêm case mới trong `createSort()` của Service
3. Thêm option trong dropdown UI

### 3. Tối ưu hóa performance
- Thêm **Redis caching** cho API responses
- **Elasticsearch** cho full-text search
- **Image optimization** với CDN
- **Lazy loading** cho images

## Best Practices đã áp dụng

1. **Separation of concerns** - Controller/Service/Repository
2. **DTO pattern** cho data transfer
3. **Responsive design** với mobile-first
4. **Error handling** với fallback UI
5. **Performance optimization** với debouncing
6. **Accessibility** với proper ARIA labels
7. **SEO-friendly** URLs và meta tags

Giao diện đã hoàn thiện và sẵn sàng sử dụng!