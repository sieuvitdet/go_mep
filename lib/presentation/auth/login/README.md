# Login Screen Implementation

## Tổng quan

Đây là implementation của màn hình đăng nhập dựa trên thiết kế Figma với đầy đủ tính năng responsive và tùy chỉnh.

## Các file chính

### 1. `login_screen_figma.dart`
- Màn hình đăng nhập chính xác theo thiết kế Figma
- Kích thước cố định 428x926 (iPhone 14 Plus)
- Sử dụng các widget tùy chỉnh

### 2. `responsive_login_screen.dart`
- Màn hình đăng nhập responsive
- Tự động điều chỉnh kích thước theo màn hình
- Có validation và loading states
- Hỗ trợ scroll trên màn hình nhỏ

### 3. `login_demo.dart`
- Demo app để test cả hai phiên bản
- Có switch để chuyển đổi giữa Figma và Responsive

## Các widget tùy chỉnh

### FigmaInputField
```dart
FigmaInputField(
  hintText: 'Nhập số điện thoại',
  controller: phoneController,
  keyboardType: TextInputType.phone,
)
```

### FigmaPasswordField
```dart
FigmaPasswordField(
  hintText: 'Nhập mật khẩu',
  controller: passwordController,
)
```

### FigmaButton
```dart
FigmaButton(
  text: 'Đăng nhập',
  type: FigmaButtonType.primary,
  onPressed: () {},
)
```

### FigmaLogo
```dart
FigmaLogo(
  size: 85.0, // optional
  color: Colors.white, // optional
)
```

## Theme và Colors

Tất cả màu sắc và kích thước được định nghĩa trong `lib/common/theme/figma_colors.dart`:

- **FigmaColors**: Màu sắc theo thiết kế
- **FigmaTextStyles**: Font styles theo thiết kế  
- **FigmaDimensions**: Kích thước và spacing

## Cách sử dụng

### 1. Sử dụng màn hình Figma (cố định)
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginScreenFigma()),
);
```

### 2. Sử dụng màn hình Responsive
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ResponsiveLoginScreen()),
);
```

### 3. Sử dụng Demo
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginDemo()),
);
```

## Tính năng

### Màn hình Figma
- ✅ Thiết kế chính xác theo Figma
- ✅ Status bar với thời gian và icons
- ✅ Logo với icon xe hơi
- ✅ Input fields với placeholder
- ✅ Password field với toggle visibility
- ✅ Buttons với các style khác nhau
- ✅ Links cho forgot password và register

### Màn hình Responsive
- ✅ Tất cả tính năng của màn hình Figma
- ✅ Responsive design cho mọi kích thước màn hình
- ✅ Form validation
- ✅ Loading states
- ✅ Error handling
- ✅ Scroll support
- ✅ Dialog confirmations

## Customization

### Thay đổi màu sắc
Chỉnh sửa trong `figma_colors.dart`:
```dart
static const Color primaryColor = Color(0xFF000000);
static const Color textColor = Color(0xFFFFFFFF);
```

### Thay đổi kích thước
Chỉnh sửa trong `figma_colors.dart`:
```dart
static const double inputHeight = 48.0;
static const double buttonHeight = 48.0;
```

### Thay đổi font
Chỉnh sửa trong `figma_colors.dart`:
```dart
static const TextStyle inputText = TextStyle(
  fontFamily: 'Roboto Condensed',
  fontWeight: FontWeight.w500,
  fontSize: 16,
);
```

## Dependencies

- `flutter/material.dart` - UI framework
- Không cần dependencies bên ngoài

## Notes

- Màn hình được thiết kế cho iPhone 14 Plus (428x926)
- Responsive version tự động điều chỉnh cho các kích thước khác
- Tất cả màu sắc và kích thước đều theo thiết kế Figma
- Code được tổ chức theo Clean Architecture pattern
