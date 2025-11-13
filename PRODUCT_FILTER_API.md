# API Bộ Lọc Sản Phẩm

## Các endpoint mới đã được thêm vào:

### 1. GET /api/v1/products/filter (Có phân trang)
Lấy sản phẩm với bộ lọc nâng cao và phân trang

**Tham số query:**
- `name` (String): Tìm kiếm theo tên sản phẩm (không phân biệt hoa thường)
- `color` (String): Lọc theo màu sắc
- `productSize` (String): Lọc theo kích thước
- `minPrice` (Double): Giá tối thiểu
- `maxPrice` (Double): Giá tối đa
- `minStock` (Integer): Tồn kho tối thiểu
- `categoryId` (Long): Lọc theo ID danh mục
- `categoryIds` (List<Long>): Lọc theo nhiều ID danh mục
- `sortBy` (String): Sắp xếp theo (name, price, createdAt, stock) - mặc định: name
- `sortDirection` (String): Hướng sắp xếp (ASC, DESC) - mặc định: ASC
- `page` (Integer): Số trang (bắt đầu từ 0) - mặc định: 0
- `pageSize` (Integer): Số sản phẩm trên mỗi trang - mặc định: 10

**Ví dụ:**
```
GET /api/v1/products/filter?name=áo&color=red&minPrice=100000&maxPrice=500000&sortBy=price&sortDirection=ASC&page=0&pageSize=20
```

**Response:**
```json
{
    "content": [
        {
            "id": 1,
            "name": "Áo thun nam",
            "price": 250000.0,
            "image": "image1.jpg"
        }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 5,
    "totalPages": 1,
    "first": true,
    "last": true,
    "hasNext": false,
    "hasPrevious": false
}
```

### 2. GET /api/v1/products/search (Không phân trang)
Tìm kiếm sản phẩm với bộ lọc nâng cao nhưng không phân trang

**Tham số query:**
- `name` (String): Tìm kiếm theo tên sản phẩm
- `color` (String): Lọc theo màu sắc
- `productSize` (String): Lọc theo kích thước
- `minPrice` (Double): Giá tối thiểu
- `maxPrice` (Double): Giá tối đa
- `minStock` (Integer): Tồn kho tối thiểu
- `categoryId` (Long): Lọc theo ID danh mục

**Ví dụ:**
```
GET /api/v1/products/search?name=áo&categoryId=1&minPrice=100000
```

**Response:**
```json
[
    {
        "id": 1,
        "name": "Áo thun nam",
        "price": 250000.0,
        "image": "image1.jpg"
    },
    {
        "id": 2,
        "name": "Áo sơ mi nữ",
        "price": 350000.0,
        "image": "image2.jpg"
    }
]
```

### 3. POST /api/v1/products/filter (Với request body)
Lấy sản phẩm với bộ lọc phức tạp thông qua request body

**Request Body:**
```json
{
    "name": "áo",
    "color": "red",
    "productSize": "M",
    "minPrice": 100000,
    "maxPrice": 500000,
    "minStock": 10,
    "categoryId": 1,
    "categoryIds": [1, 2, 3],
    "sortBy": "price",
    "sortDirection": "DESC",
    "page": 0,
    "pageSize": 15
}
```

**Response:** Giống như GET /api/v1/products/filter

## Các tính năng nổi bật:

1. **Tìm kiếm không phân biệt hoa thường** cho tên sản phẩm
2. **Phân trang và sắp xếp** linh hoạt
3. **Lọc theo nhiều danh mục** với categoryIds
4. **Lọc theo khoảng giá và tồn kho**
5. **Lọc theo màu sắc và kích thước**
6. **Tất cả tham số đều optional** - có thể kết hợp tùy ý

## Endpoint cũ vẫn hoạt động:
- `GET /api/v1/products` - Tìm kiếm cơ bản (backward compatibility)

## Cách sử dụng trong Frontend:

### JavaScript/Fetch API:
```javascript
// Lọc với phân trang
const response = await fetch('/api/v1/products/filter?name=áo&page=0&pageSize=10&sortBy=price&sortDirection=ASC');
const data = await response.json();

// Lọc với POST body
const filterData = {
    name: 'áo',
    categoryIds: [1, 2],
    minPrice: 100000,
    maxPrice: 500000,
    page: 0,
    pageSize: 20
};

const response = await fetch('/api/v1/products/filter', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify(filterData)
});
const products = await response.json();
```