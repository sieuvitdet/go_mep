# Temporary Report Markers Feature

Tính năng tạo marker tạm thời khi báo cáo **Tắc Đường**, **Ngập Nước**, hoặc **Tai Nạn**. Markers tự động ẩn sau **1 tiếng**.

## Tổng Quan

Khi người dùng báo cáo (qua AI Assistant hoặc nút bấm):
1. ✅ Hệ thống lấy vị trí hiện tại (GPS)
2. ✅ Tạo marker trên bản đồ tại vị trí đó
3. ✅ Lưu vào database với thời gian hết hạn (1 tiếng)
4. ✅ Hiển thị marker trên map với màu sắc tương ứng
5. ✅ Tự động xóa sau 1 tiếng bằng cleanup service

## Cấu Trúc

### 1. Model (lib/data/model/res/)

#### `temporary_report_marker_model.dart`

```dart
enum ReportType {
  trafficJam,      // Tắc đường - Orange marker
  waterlogging,    // Ngập nước - Blue marker
  accident;        // Tai nạn - Red marker
}

class TemporaryReportMarkerModel {
  final int id;
  final ReportType reportType;
  final double latitude;
  final double longitude;
  final String? description;
  final DateTime createdAt;
  final DateTime expiresAt;  // Auto-calculated: createdAt + 1 hour

  bool get isExpired;
  Duration get timeUntilExpiry;
  String get formattedRemainingTime;  // "45 phút", "1 giờ 30 phút"
}
```

### 2. Database

#### Table Schema
```sql
CREATE TABLE temporary_report_markers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reportType INTEGER NOT NULL,  -- 0=trafficJam, 1=waterlogging, 2=accident
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  description TEXT,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  expiresAt DATETIME NOT NULL,
  userReportedBy TEXT
);
```

#### Files:
- `tables/temporary_report_marker_table.dart` - Drift table definition
- `daos/temporary_report_marker_dao.dart` - Data access methods

### 3. Repository

#### `temporary_report_marker_repository.dart`

```dart
// Create marker at current location (GPS)
final marker = await repository.createReportAtCurrentLocation(
  reportType: ReportType.trafficJam,
  description: 'Báo cáo từ người dùng',
);

// Create at specific location
final marker = await repository.createReportAtLocation(
  reportType: ReportType.waterlogging,
  latitude: 10.762622,
  longitude: 106.660172,
);

// Get all active markers (not expired)
final markers = await repository.getAllActiveMarkers();

// Delete expired markers
final count = await repository.deleteExpiredMarkers();

// Statistics
final stats = await repository.getStatistics();
```

### 4. Auto-Cleanup Service

#### `temporary_marker_cleanup_service.dart`

Service tự động xóa markers hết hạn mỗi **5 phút**.

```dart
// Auto-started in main.dart
temporaryMarkerCleanupService.start();

// Manual cleanup
await temporaryMarkerCleanupService.triggerCleanup();

// Stop service
temporaryMarkerCleanupService.stop();
```

**Features:**
- ⏱️ Chạy mỗi 5 phút
- 🧹 Tự động xóa markers hết hạn
- 📊 Log statistics sau mỗi lần cleanup
- 🔧 Có thể trigger manual

### 5. Map Integration

#### MapBloc (`map_bloc.dart`)

```dart
// Load và hiển thị markers
Future<Set<Marker>> _loadTemporaryReportMarkers() async {
  final markers = await repository.getAllActiveMarkers();

  // Convert to Google Maps markers with icons
  for (var reportMarker in markers) {
    BitmapDescriptor icon;
    switch (reportMarker.reportType) {
      case ReportType.trafficJam:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
        break;
      case ReportType.waterlogging:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        break;
      case ReportType.accident:
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        break;
    }

    mapMarkers.add(Marker(
      markerId: MarkerId('temp_report_${reportMarker.id}'),
      position: LatLng(reportMarker.latitude, reportMarker.longitude),
      icon: icon,
      infoWindow: InfoWindow(
        title: reportMarker.reportType.displayName,
        snippet: 'Báo cáo ${reportMarker.formattedRemainingTime} trước',
      ),
    ));
  }
}
```

**Marker Colors:**
- 🟠 **Orange** - Tắc đường (Traffic Jam)
- 🔵 **Blue** - Ngập nước (Waterlogging)
- 🔴 **Red** - Tai nạn (Accident)

### 6. AI Assistant Integration

#### `feature_action_handler.dart`

```dart
// Khi user báo "tắc đường" hoặc "ngập nước"
static void _handleReportFeature(
  BuildContext context, {
  required ReportType reportType,
  required String title,
  required String message,
}) async {
  // Show confirmation dialog
  showDialog(...);

  // On confirm:
  final marker = await repository.createReportAtCurrentLocation(
    reportType: reportType,
    description: 'Báo cáo từ người dùng',
  );

  // Show success message
  _showInfoSnackBar(
    context,
    'Đã báo cáo ${reportType.displayName} thành công!\n'
    'Marker sẽ tự động ẩn sau 1 tiếng.',
  );
}
```

## Cách Sử Dụng

### 1. Qua AI Assistant

```dart
// User input
"báo tắc đường"
"báo ngập nước"
"báo tai nạn"

// AI recognizes → creates marker at current location
```

### 2. Programmatically

```dart
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/data/model/res/temporary_report_marker_model.dart';

final repo = Globals.temporaryReportMarkerRepository;

// Create traffic jam report
final marker = await repo?.createReportAtCurrentLocation(
  reportType: ReportType.trafficJam,
  description: 'Kẹt xe nghiêm trọng',
);

// Get all active markers
final markers = await repo?.getAllActiveMarkers();

// Get by type
final trafficJams = await repo?.getMarkersByType(ReportType.trafficJam);
```

### 3. Statistics

```dart
final stats = await repo?.getStatistics();

print('Active markers: ${stats['active']}');
print('Tắc đường: ${stats['trafficJam']}');
print('Ngập nước: ${stats['waterlogging']}');
print('Tai nạn: ${stats['accident']}');
print('Expired: ${stats['expired']}');
```

## Lifecycle

```
User reports → GPS location → Create marker → Save to DB
                                              ↓
                                         expiresAt = now + 1h
                                              ↓
                                    Display on map (colored icon)
                                              ↓
                              [Cleanup service runs every 5 min]
                                              ↓
                                     After 1 hour → Auto-delete
```

## Database Migration

Schema version: **4 → 5**

```dart
// Migration
if (from == 4 && to == 5) {
  await m.createTable(temporaryReportMarkers);
}
```

## Configuration

### Expiry Duration
Default: **1 hour**

Để thay đổi:
```dart
// In repository
final marker = await repository.createReportAtCurrentLocation(
  reportType: ReportType.trafficJam,
  expiryDuration: Duration(hours: 2), // Custom: 2 hours
);
```

### Cleanup Interval
Default: **5 minutes**

Để thay đổi:
```dart
// In main.dart
final temporaryMarkerCleanupService = TemporaryMarkerCleanupService(
  repository: temporaryReportMarkerRepo,
  cleanupInterval: Duration(minutes: 10), // Custom: 10 minutes
);
```

## Testing

### Manual Testing

```dart
// 1. Create test marker
await repo.createReportAtLocation(
  reportType: ReportType.trafficJam,
  latitude: 10.762622,
  longitude: 106.660172,
  expiryDuration: Duration(seconds: 30), // Expires in 30 seconds
);

// 2. Wait 30 seconds

// 3. Trigger cleanup
await Globals.temporaryMarkerCleanupService?.triggerCleanup();

// 4. Check markers
final markers = await repo.getAllActiveMarkers();
print('Active markers: ${markers.length}'); // Should be 0
```

### Expected Logs

```
✅ Starting temporary marker cleanup service
   Cleanup interval: 5 minutes

🧹 Running cleanup of expired markers...
   Cleaned up 3 expired markers
   Active markers: 12
     - Tắc đường: 5
     - Ngập nước: 4
     - Tai nạn: 3
```

## API Reference

### TemporaryReportMarkerRepository

#### Methods:
- `getAllActiveMarkers()` → `Future<List<TemporaryReportMarkerModel>>`
- `getMarkersByType(ReportType type)` → `Future<List<TemporaryReportMarkerModel>>`
- `getMarkerById(int id)` → `Future<TemporaryReportMarkerModel?>`
- `createReportAtCurrentLocation({...})` → `Future<TemporaryReportMarkerModel>`
- `createReportAtLocation({...})` → `Future<TemporaryReportMarkerModel>`
- `deleteMarker(int id)` → `Future<void>`
- `deleteExpiredMarkers()` → `Future<int>`
- `deleteAllMarkers()` → `Future<void>`
- `countActiveMarkers()` → `Future<int>`
- `countExpiredMarkers()` → `Future<int>`
- `getStatistics()` → `Future<Map<String, int>>`
- `watchActiveMarkers()` → `Stream<List<TemporaryReportMarkerModel>>`

### TemporaryMarkerCleanupService

#### Methods:
- `start()` → `void` - Start periodic cleanup
- `stop()` → `void` - Stop cleanup service
- `triggerCleanup()` → `Future<void>` - Manual cleanup
- `isRunning` → `bool` - Check if running

## Notes

- ✅ Markers tự động xóa sau 1 tiếng
- ✅ Cleanup service chạy mỗi 5 phút
- ✅ Sử dụng GPS để lấy vị trí thiết bị
- ✅ Màu sắc khác nhau cho từng loại báo cáo
- ✅ Hiển thị thời gian còn lại trong info window
- ⚠️ Cần quyền GPS để tạo marker
- ⚠️ Markers chỉ lưu local, không sync với server
- ⚠️ Nếu app bị kill, cleanup service sẽ dừng (restart khi app mở lại)
