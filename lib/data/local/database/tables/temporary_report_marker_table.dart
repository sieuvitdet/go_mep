import 'package:drift/drift.dart';

/// Database table for storing temporary report markers
/// These markers auto-expire after a set duration (default: 1 hour)
@DataClassName('TemporaryReportMarkerEntity')
class TemporaryReportMarkers extends Table {
  @override
  String get tableName => 'temporary_report_markers';

  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// Type of report: 0=trafficJam, 1=waterlogging, 2=accident
  IntColumn get reportType => integer()();

  /// Latitude coordinate
  RealColumn get latitude => real()();

  /// Longitude coordinate
  RealColumn get longitude => real()();

  /// Optional description of the report
  TextColumn get description => text().nullable()();

  /// Timestamp when the marker was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the marker expires and should be removed
  DateTimeColumn get expiresAt => dateTime()();

  /// Optional user ID who reported this
  TextColumn get userReportedBy => text().nullable()();
}
