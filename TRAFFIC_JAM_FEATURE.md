# Traffic Jam Feature (Tính năng Tắc Đường)

## Tổng Quan

Tính năng vẽ tắc đường trên bản đồ Google Maps, cho phép hiển thị các tuyến đường bị tắc nghẽn giao thông.

## Cấu Trúc

### 1. Model (lib/data/model/res/)
- **traffic_jam_route_model.dart**: Model cho tuyến đường tắc nghẽn
  - `TrafficJamRouteModel`: Thông tin tuyến đường
  - `TrafficJamPoint`: Điểm tọa độ trên tuyến đường

### 2. Database (lib/data/local/database/)
- **tables/traffic_jam_table.dart**: Bảng lưu trữ dữ liệu tắc đường
- **daos/traffic_jam_dao.dart**: Data Access Object

### 3. Repository (lib/data/repositories/)
- **traffic_jam_repository.dart**: Quản lý dữ liệu tắc đường

### 4. Map Integration (lib/presentation/base/google_map/)
- **bloc/map_bloc.dart**: Đã thêm logic load và vẽ polylines cho tắc đường

## Cách Sử Dụng

### 1. Build Code Generation

Trước khi chạy app, bạn cần generate code cho Drift và JSON serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Import JSON Data

Tính năng hỗ trợ import dữ liệu từ file JSON. Xem file mẫu tại:
```
assets/json/traffic_jam_example.json
```

#### Cấu trúc JSON:

```json
[
  {
    "routeId": 1,
    "routeName": "Tên tuyến đường",
    "lineColor": "#FF5722",
    "lineWidth": 6.0,
    "description": "Mô tả (optional)",
    "points": [
      "10.737973, 106.730258",
      "10.738234, 106.731456",
      "10.738891, 106.732012"
    ]
  }
]
```

#### Các trường:
- **routeId** (int): ID duy nhất của tuyến đường
- **routeName** (string): Tên tuyến đường
- **lineColor** (string): Màu sắc hex (ví dụ: "#FF5722" - Deep Orange)
- **lineWidth** (double): Độ dày đường vẽ (mặc định: 5.0)
- **description** (string, optional): Mô tả tuyến đường
- **points** (array of strings): Danh sách tọa độ dạng "latitude, longitude"
  - Format: `"lat, lng"` - Ví dụ: `"10.737973, 106.730258"`
  - Thứ tự trong mảng sẽ được dùng làm orderIndex tự động

#### Gợi ý màu sắc:

```
#FF5722 - Deep Orange (Tắc nhẹ)
#F44336 - Red (Tắc trung bình)
#E91E63 - Pink (Tắc nghiêm trọng)
#9C27B0 - Purple (Tắc rất nghiêm trọng)
```

### 3. Sử dụng Repository

```dart
import 'package:go_mep_application/common/theme/globals/globals.dart';

// Get repository
final trafficJamRepo = Globals.trafficJamRepository;

// Import from JSON
await trafficJamRepo?.importFromJson(jsonData);

// Get all routes
final routes = await trafficJamRepo?.getAllRoutes();

// Add single route
await trafficJamRepo?.addRoute(newRoute);

// Clear all data
await trafficJamRepo?.clearAll();

// Export to JSON
final jsonData = await trafficJamRepo?.exportToJson();
```

### 4. Dữ Liệu Mẫu

App tự động tạo 3 tuyến đường mẫu khi khởi động lần đầu:
- Tắc Đường Mẫu 1 (Deep Orange)
- Tắc Đường Mẫu 2 (Red)
- Tắc Đường Mẫu 3 (Pink)

Bạn có thể xóa và import dữ liệu thực tế của mình.

## Hiển Thị Trên Bản Đồ

Tuyến đường tắc nghẽn sẽ tự động hiển thị dưới dạng polylines (đường vẽ) trên Google Maps khi app khởi động.

### Đặc điểm polylines:
- Màu sắc: Theo lineColor được định nghĩa
- Độ dày: Theo lineWidth
- Rounded caps (đầu và cuối đường tròn)
- Geodesic (đường cong theo hình cầu Trái Đất)

## Database Schema

```sql
CREATE TABLE traffic_jam (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  routeId INTEGER NOT NULL,
  routeName TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  orderIndex INTEGER NOT NULL,
  lineColor TEXT DEFAULT '#FF5722',
  lineWidth REAL DEFAULT 5.0,
  description TEXT,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## Migration

Database schema version đã được tăng từ 3 lên 4. Migration tự động tạo bảng `traffic_jam` khi app cập nhật.

## API Reference

### TrafficJamRepository

#### Methods:

- `getAllRoutes()` → `Future<List<TrafficJamRouteModel>>`
- `getRouteById(int routeId)` → `Future<TrafficJamRouteModel?>`
- `addRoute(TrafficJamRouteModel route)` → `Future<void>`
- `addRoutes(List<TrafficJamRouteModel> routes)` → `Future<void>`
- `deleteRoute(int routeId)` → `Future<void>`
- `clearAll()` → `Future<void>`
- `countRoutes()` → `Future<int>`
- `countPoints()` → `Future<int>`
- `watchAllRoutes()` → `Stream<List<TrafficJamRouteModel>>`
- `initializeSampleData()` → `Future<void>`
- `importFromJson(List<Map<String, dynamic>> jsonData)` → `Future<void>`
- `exportToJson()` → `Future<List<Map<String, dynamic>>>`

## Notes

- ✅ Tính năng tương tự với Waterlogging (Ngập nước)
- ✅ Sử dụng Drift database cho local storage
- ✅ Hỗ trợ JSON import/export với **format đơn giản**
- ✅ Points chỉ cần array of strings: `["lat, lng", "lat, lng", ...]`
- ✅ Tự động parse orderIndex từ vị trí trong array
- ✅ Tự động hiển thị trên bản đồ
- ✅ Cache-first strategy (dữ liệu local, không cần API)
- ⚠️ Nhớ chạy `build_runner` sau khi tạo/sửa model
- ⚠️ Format points: `"latitude, longitude"` (có dấu phẩy và khoảng trắng)
