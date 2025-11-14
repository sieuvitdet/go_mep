import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/places_table.dart';

part 'places_dao.g.dart';

@DriftAccessor(tables: [Places])
class PlacesDao extends DatabaseAccessor<AppDatabase> with _$PlacesDaoMixin {
  PlacesDao(AppDatabase db) : super(db);

  // Watch all places (reactive stream)
  Stream<List<PlaceEntity>> watchAllPlaces() {
    return (select(places)
          ..orderBy([
            (p) => OrderingTerm.desc(p.cachedAt),
          ]))
        .watch();
  }

  // Get all places (one-time query)
  Future<List<PlaceEntity>> getAllPlaces() {
    return (select(places)
          ..orderBy([
            (p) => OrderingTerm.desc(p.cachedAt),
          ]))
        .get();
  }

  // Search places by name (for autocomplete/search history)
  Future<List<PlaceEntity>> searchPlacesByName(String query) {
    return (select(places)
          ..where((p) => p.name.like('%$query%'))
          ..orderBy([
            (p) => OrderingTerm.desc(p.cachedAt),
          ]))
        .get();
  }

  // Get place by ID
  Future<PlaceEntity?> getPlaceById(String id) {
    return (select(places)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  // Get places by type
  Future<List<PlaceEntity>> getPlacesByType(String type) {
    return (select(places)
          ..where((p) => p.types.like('%$type%'))
          ..orderBy([
            (p) => OrderingTerm.desc(p.cachedAt),
          ]))
        .get();
  }

  // Get places within distance (simplified - you may want to use a proper geospatial query)
  // This is a basic implementation using bounding box
  Future<List<PlaceEntity>> getPlacesNearby({
    required double centerLat,
    required double centerLng,
    required double radiusInKm,
  }) {
    // Approximate bounding box (1 degree ≈ 111 km)
    final latDelta = radiusInKm / 111.0;
    final lngDelta = radiusInKm / (111.0 * 0.8); // Adjust for longitude

    return (select(places)
          ..where((p) =>
              p.latitude.isBetweenValues(centerLat - latDelta, centerLat + latDelta) &
              p.longitude.isBetweenValues(centerLng - lngDelta, centerLng + lngDelta))
          ..orderBy([
            (p) => OrderingTerm.desc(p.rating),
          ]))
        .get();
  }

  // Get top rated places
  Future<List<PlaceEntity>> getTopRatedPlaces({int limit = 10}) {
    return (select(places)
          ..where((p) => p.rating.isNotNull())
          ..orderBy([
            (p) => OrderingTerm.desc(p.rating),
          ])
          ..limit(limit))
        .get();
  }

  // Insert single place
  Future<void> insertPlace(PlaceEntity place) {
    return into(places).insertOnConflictUpdate(
      place.copyWith(cachedAt: DateTime.now()),
    );
  }

  // Batch insert places
  Future<void> insertPlaces(List<PlaceEntity> items) async {
    final now = DateTime.now();
    final itemsWithTimestamp = items.map((p) => p.copyWith(cachedAt: now)).toList();

    await batch((batch) {
      batch.insertAllOnConflictUpdate(places, itemsWithTimestamp);
    });
  }

  // Update place
  Future<void> updatePlace(PlacesCompanion place) {
    return (update(places)..where((p) => p.id.equals(place.id.value))).write(
      place.copyWith(cachedAt: Value(DateTime.now())),
    );
  }

  // Delete place by ID
  Future<void> deletePlace(String id) {
    return (delete(places)..where((p) => p.id.equals(id))).go();
  }

  // Delete places older than specified date (cache cleanup)
  Future<void> deleteOlderThan(DateTime date) {
    return (delete(places)..where((p) => p.cachedAt.isSmallerThan(Variable(date)))).go();
  }

  // Clear all places
  Future<void> clearAll() {
    return delete(places).go();
  }

  // Get total count
  Future<int> getCount() async {
    final count = countAll();
    final query = selectOnly(places)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // Check if place is cached
  Future<bool> isPlaceCached(String id) async {
    final place = await getPlaceById(id);
    return place != null;
  }

  // Check if place cache is stale
  Future<bool> isPlaceCacheStale(String id, Duration maxAge) async {
    final place = await getPlaceById(id);
    if (place == null) return true;

    final now = DateTime.now();
    final age = now.difference(place.cachedAt);
    return age > maxAge;
  }
}
