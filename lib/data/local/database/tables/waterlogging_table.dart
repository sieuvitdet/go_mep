import 'package:drift/drift.dart';

/// Bảng lưu trữ các điểm waterlogging (ngập úng)
/// Mỗi route được xác định bởi routeId
@DataClassName('WaterloggingEntity')
class Waterloggings extends Table {
  @override
  String get tableName => 'waterlogging';

  /// ID duy nhất của điểm
  IntColumn get id => integer().autoIncrement()();

  /// ID của tuyến đường (để nhóm các điểm lại)
  IntColumn get routeId => integer()();

  /// Tên tuyến đường
  TextColumn get routeName => text().nullable()();

  /// Vĩ độ
  RealColumn get latitude => real()();

  /// Kinh độ
  RealColumn get longitude => real()();

  /// Thứ tự điểm trong tuyến đường
  IntColumn get orderIndex => integer()();

  /// Màu của polyline (hex color)
  TextColumn get lineColor => text().withDefault(const Constant('#2196F3'))();

  /// Độ dày của đường
  RealColumn get lineWidth => real().withDefault(const Constant(5.0))();

  /// Mô tả
  TextColumn get description => text().nullable()();

  /// Thời gian tạo
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Thời gian cập nhật
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
