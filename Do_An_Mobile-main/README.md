# Ứng Dụng Thương Mại Điện Tử | E-commerce Mobile App

## Cấu Trúc Thư Mục | Project Structure

```
lib/
├── model/
│   └── product.dart              # Model sản phẩm
├── provider/
│   ├── category_provider.dart    # Provider quản lý danh mục
│   └── product_provider.dart     # Provider quản lý sản phẩm
├── screens/
│   ├── cartpage.dart            # Màn hình giỏ hàng
│   ├── checkout.dart            # Màn hình thanh toán
│   ├── detailpage.dart          # Màn hình chi tiết sản phẩm
│   ├── homepage.dart            # Màn hình trang chủ
│   ├── listproduct.dart         # Màn hình danh sách sản phẩm
│   ├── login.dart               # Màn hình đăng nhập
│   ├── signup.dart              # Màn hình đăng ký
│   └── welcomepage.dart         # Màn hình chào mừng
├── widgets/
│   ├── changeScreens.dart       # Widget chuyển màn hình
│   ├── importProduct.dart       # Widget hiển thị sản phẩm
│   ├── mybutton.dart           # Widget nút tùy chỉnh
│   ├── mytextformField.dart    # Widget form nhập liệu
│   └── passwordtextformField.dart # Widget nhập mật khẩu
├── firebase_options.dart        # Cấu hình Firebase
└── main.dart                    # File khởi động ứng dụng
```

## Tính Năng Chính | Main Features

### 1. Xác Thực Người Dùng | User Authentication
- Đăng nhập/Đăng ký với Firebase Auth
- Quản lý phiên đăng nhập
- Bảo mật thông tin người dùng

### 2. Quản Lý Sản Phẩm | Product Management
- Hiển thị danh sách sản phẩm
- Phân loại theo danh mục
- Xem chi tiết sản phẩm
- Tìm kiếm sản phẩm

### 3. Giỏ Hàng | Shopping Cart
- Thêm/xóa sản phẩm
- Quản lý số lượng
- Tính tổng tiền

### 4. Thanh Toán | Checkout
- Quy trình thanh toán
- Xác nhận đơn hàng

## Công Nghệ Sử Dụng | Technologies Used

- Flutter Framework
- Firebase Authentication
- Firebase Cloud Firestore
- Provider State Management

## Cài Đặt | Installation

```bash
# Clone dự án | Clone the repository
git clone [repository-url]

# Cài đặt dependencies | Install dependencies
flutter pub get

# Chạy ứng dụng | Run the app
flutter run
```

## Cấu Hình Firebase | Firebase Setup

1. Tạo dự án Firebase mới | Create new Firebase project
2. Thêm ứng dụng Android/iOS | Add Android/iOS app
3. Tải file cấu hình | Download config files:
   - `google-services.json` cho Android
   - `GoogleService-Info.plist` cho iOS
4. Thêm file cấu hình vào dự án | Add config files to project

## Đóng Góp | Contributing

1. Fork dự án | Fork the project
2. Tạo nhánh tính năng | Create feature branch
3. Commit thay đổi | Commit changes
4. Push lên nhánh | Push to branch
5. Tạo Pull Request | Create Pull Request

## Tác Giả | Author

[Tên tác giả | Author name]

## Giấy Phép | License

MIT License