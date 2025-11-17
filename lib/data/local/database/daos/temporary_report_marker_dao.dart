import 'package:drift/drift.dart';
import 'package:go_mep_application/data/local/database/app_database.dart';
import 'package:go_mep_application/data/local/database/tables/temporary_report_marker_table.dart';
import 'package:go_mep_application/data/model/res/temporary_report_marker_model.dart';

part 'temporary_report_marker_dao.g.dart';

/// Data Access Object for temporary report markers
@DriftAccessor(tables: [TemporaryReportMarkers])
class TemporaryReportMarkerDao extends DatabaseAccessor<AppDatabase>
    with _$TemporaryReportMarkerDaoMixin {
  TemporaryReportMarkerDao(AppDatabase db) : super(db);

  /// Get all active (non-expired) markers
  Future<List<TemporaryReportMarkerModel>> getAllActiveMarkers() async {
    final now = DateTime.now();
    final entities = await (select(temporaryReportMarkers)
          ..where((t) => t.expiresAt.isBiggerThanValue(now))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    return entities.map(_entityToModel).toList();
  }

  /// Get markers by type
  Future<List<TemporaryReportMarkerModel>> getMarkersByType(
      ReportType type) async {
    final now = DateTime.now();
    final entities = await (select(temporaryReportMarkers)
          ..where((t) =>
              t.reportType.equals(type.index) &
              t.expiresAt.isBiggerThanValue(now))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    return entities.map(_entityToModel).toList();
  }

  /// Get marker by ID
  Future<TemporaryReportMarkerModel?> getMarkerById(int id) async {
    final entity = await (select(temporaryReportMarkers)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (entity == null) return null;
    return _entityToModel(entity);
  }

  /// Insert a new marker
  Future<int> insertMarker(TemporaryReportMarkerModel marker) {
    return into(temporaryReportMarkers).insert(
      TemporaryReportMarkersCompanion.insert(
        reportType: marker.reportType.index,
        latitude: marker.latitude,
        longitude: marker.longitude,
        description: Value(marker.description),
        expiresAt: marker.expiresAt,
        userReportedBy: Value(marker.userReportedBy),
      ),
    );
  }

  /// Delete a marker
  Future<int> deleteMarker(int id) {
    return (delete(temporaryReportMarkers)..where((t) => t.id.equals(id))).go();
  }

  /// Delete all expired markers
  Future<int> deleteExpiredMarkers() {
    final now = DateTime.now();
    return (delete(temporaryReportMarkers)
          ..where((t) => t.expiresAt.isSmallerOrEqualValue(now)))
        .go();
  }

  /// Delete all markers
  Future<int> deleteAllMarkers() {
    return delete(temporaryReportMarkers).go();
  }

  /// Count active markers
  Future<int> countActiveMarkers() async {
    final now = DateTime.now();
    final countExp = temporaryReportMarkers.id.count();
    final query = selectOnly(temporaryReportMarkers)
      ..addColumns([countExp])
      ..where(temporaryReportMarkers.expiresAt.isBiggerThanValue(now));

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  /// Count expired markers
  Future<int> countExpiredMarkers() async {
    final now = DateTime.now();
    final countExp = temporaryReportMarkers.id.count();
    final query = selectOnly(temporaryReportMarkers)
      ..addColumns([countExp])
      ..where(temporaryReportMarkers.expiresAt.isSmallerOrEqualValue(now));

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  /// Watch active markers for real-time updates
  Stream<List<TemporaryReportMarkerModel>> watchActiveMarkers() {
    final now = DateTime.now();
    return (select(temporaryReportMarkers)
          ..where((t) => t.expiresAt.isBiggerThanValue(now))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((entities) => entities.map(_entityToModel).toList());
  }

  /// Convert entity to model
  TemporaryReportMarkerModel _entityToModel(
      TemporaryReportMarkerEntity entity) {
    return TemporaryReportMarkerModel(
      id: entity.id,
      reportType: ReportType.values[entity.reportType],
      latitude: entity.latitude,
      longitude: entity.longitude,
      description: entity.description,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
      userReportedBy: entity.userReportedBy,
    );
  }
}
