# Trang Danh Sách Sản Phẩm - Sử Dụng Dữ Liệu Từ Database

## Tổng Quan
Đã thành công viết lại trang hiển thị danh sách sản phẩm để:
- Lấy dữ liệu sản phẩm từ database PostgreSQL thay vì dữ liệu mẫu
- Hiển thị hình ảnh sản phẩm thực tế (base64) từ database
- Sử dụng API RESTful `/api/v1/products/filter` với phân trang và bộ lọc

## Kiến Trúc Hình Ảnh

### 1. Hình Ảnh Sản Phẩm (Từ Database)
- **Lưu trữ**: Cột `images` trong bảng `product` (kiểu `text[]`)
- **Định dạng**: Base64 (ví dụ: `data:image/jpeg;base64,/9j/4AAQ...`)
- **Sử dụng**: Hiển thị sản phẩm thực tế trong danh sách và chi tiết sản phẩm

### 2. Hình Ảnh Static (Local Files)
- **Đường dẫn**: `/src/main/resources/static/img/`
- **Sử dụng**: Banner, logo, icon, placeholder images
- **Ví dụ**: `/img/products/default-product.svg` (làm fallback)

## Cấu Trúc Database

### Bảng `product`
```sql
Table "public.product"
   Column    |            Type             
-------------+-----------------------------
 id          | bigint                      
 created_at  | timestamp without time zone 
 updated_at  | timestamp without time zone 
 color       | character varying(255)      
 description | character varying(255)      
 images      | text[]                      -- Mảng hình ảnh base64
 is_delete   | boolean                     
 name        | character varying(255)      
 price       | double precision            
 size        | character varying(255)      
 slug        | character varying(255)      
 stock       | integer                     
 sub_title   | character varying(255)      
 category_id | bigint                      
```

### Dữ Liệu Hiện Tại
- **Số sản phẩm**: 2 sản phẩm
- **Sản phẩm 1**: ID=1, name="dfs", price=10000, stock=10
- **Sản phẩm 2**: ID=2, name="hehehe", price=10000, stock=10
- **Hình ảnh**: Mỗi sản phẩm có 1 hình ảnh base64

## API Endpoints

### 1. Lấy Danh Sách Sản Phẩm Với Phân Trang
```
GET /api/v1/products/filter
```

**Parameters:**
- `page`: Trang hiện tại (0-based, mặc định: 0)
- `pageSize`: Số sản phẩm mỗi trang (mặc định: 10)
- `sortBy`: Sắp xếp theo (mặc định: name)
- `sortDirection`: Hướng sắp xếp (ASC/DESC, mặc định: ASC)
- `name`: Tìm kiếm theo tên
- `minPrice`, `maxPrice`: Lọc theo giá
- `categoryIds`: Lọc theo danh mục

**Response:**
```json
{
  "content": [
    {
      "id": 1,
      "name": "dfs",
      "price": 10000.0,
      "thumbnail": "data:image/jpeg;base64,/9j/4AAQ..."
    }
  ],
  "totalElements": 2,
  "totalPages": 1,
  "number": 0,
  "size": 20
}
```

### 2. Lấy Danh Mục
```
GET /api/v1/products/categories
```

### 3. Lấy Brands
```
GET /api/v1/products/brands
```

## Frontend Implementation

### JavaScript Class: `ProductsPage`
- **Chức năng**: Quản lý hiển thị danh sách sản phẩm
- **Features**:
  - Tìm kiếm theo tên sản phẩm
  - Sắp xếp theo giá (cao xuống thấp, thấp lên cao)
  - Hiển thị hình ảnh base64 từ database
  - Fallback về placeholder khi không có hình ảnh
  - Xử lý loading state

### Xử Lý Hình Ảnh
```javascript
const imageUrl = product.thumbnail && product.thumbnail.startsWith('data:image/') 
    ? product.thumbnail 
    : '/img/products/default-product.svg';
```

### Product Card Template
```javascript
createProductCard(product) {
    return `
        <div class="product-card" data-product-id="${product.id}">
            <div class="product-image">
                <img src="${imageUrl}" 
                     alt="${product.name}" 
                     loading="lazy"
                     onerror="this.src='/img/products/default-product.svg'">
            </div>
            <div class="product-info">
                <h3 class="product-name">${product.name}</h3>
                <div class="product-price">${price}</div>
            </div>
        </div>
    `;
}
```

## Cách Sử Dụng

### 1. Khởi Chạy Server
```bash
cd "e:\HCMUTE\HKI nam 3\LTWEB\BTTL 1"
java -jar target\webprojrct-0.0.1-SNAPSHOT.jar
```

### 2. Truy Cập Trang Web
- **URL**: http://localhost:8080/products
- **Trang sẽ tự động**:
  - Tải danh sách sản phẩm từ database
  - Hiển thị hình ảnh base64 thực tế
  - Cung cấp chức năng tìm kiếm và sắp xếp

### 3. Kiểm Tra API
- **API Test**: http://localhost:8080/api/v1/products/filter
- **Database**: Kết nối PostgreSQL container

## Lưu Ý Quan Trọng

### 1. Hiệu Suất
- Hình ảnh base64 trong database có thể rất lớn
- `SELECT *` sẽ không hiển thị được do kích thước hình ảnh
- Sử dụng `SELECT id, name, price, stock, is_delete` để xem dữ liệu cơ bản

### 2. Cấu Trúc Dữ Liệu
- `ProductListDto.thumbnail`: Chứa hình ảnh đầu tiên từ mảng `images`
- `Product.images`: Mảng `List<String>` chứa base64 images
- Conversion: `ProductService.convertToListDto()` tự động lấy `images[0]`

### 3. Error Handling
- Fallback images: `/img/products/default-product.svg`
- `onerror` attribute để xử lý lỗi load hình ảnh
- Loading states và error messages

## Kết Quả Đạt Được

✅ **Hoàn Thành**:
- Trang danh sách sản phẩm lấy dữ liệu từ database
- Hiển thị hình ảnh base64 thực tế từ database
- API RESTful với phân trang và bộ lọc
- Tìm kiếm và sắp xếp sản phẩm
- Responsive design với Nike-inspired UI
- Error handling và fallback images

🚀 **Server Running**: http://localhost:8080/products
📊 **Database**: 2 sản phẩm với hình ảnh base64
🎨 **Images**: Kết hợp database + local static files