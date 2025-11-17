import 'package:drift/drift.dart';

/// Database table for storing traffic jam route points
/// Each point is stored as a separate row, grouped by routeId
@DataClassName('TrafficJamEntity')
class TrafficJams extends Table {
  @override
  String get tableName => 'traffic_jam';

  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// Route identifier - groups points belonging to the same route
  IntColumn get routeId => integer()();

  /// Display name of the route
  TextColumn get routeName => text().withLength(min: 1, max: 255)();

  /// Latitude coordinate
  RealColumn get latitude => real()();

  /// Longitude coordinate
  RealColumn get longitude => real()();

  /// Order of the point in the route (for drawing polyline correctly)
  IntColumn get orderIndex => integer()();

  /// Hex color code for the polyline (e.g., '#FF5722')
  TextColumn get lineColor => text().withLength(min: 7, max: 9).withDefault(const Constant('#FF5722'))();

  /// Width of the polyline
  RealColumn get lineWidth => real().withDefault(const Constant(5.0))();

  /// Optional description of the route
  TextColumn get description => text().nullable()();

  /// Timestamp when the record was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the record was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
