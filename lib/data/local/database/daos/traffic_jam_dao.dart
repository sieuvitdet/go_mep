import 'package:drift/drift.dart';
import 'package:go_mep_application/data/local/database/app_database.dart';
import 'package:go_mep_application/data/local/database/tables/traffic_jam_table.dart';
import 'package:go_mep_application/data/model/res/traffic_jam_route_model.dart';

part 'traffic_jam_dao.g.dart';

/// Data Access Object for traffic jam routes
@DriftAccessor(tables: [TrafficJams])
class TrafficJamDao extends DatabaseAccessor<AppDatabase> with _$TrafficJamDaoMixin {
  TrafficJamDao(AppDatabase db) : super(db);

  /// Get all points for a specific route, ordered by orderIndex
  Future<List<TrafficJamEntity>> getPointsByRouteId(int routeId) {
    return (select(trafficJams)
          ..where((t) => t.routeId.equals(routeId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
  }

  /// Get all routes grouped by routeId
  Future<List<TrafficJamRouteModel>> getAllRoutes() async {
    final allPoints = await (select(trafficJams)
          ..orderBy([
            (t) => OrderingTerm.asc(t.routeId),
            (t) => OrderingTerm.asc(t.orderIndex),
          ]))
        .get();

    // Group points by routeId
    final Map<int, List<TrafficJamEntity>> groupedByRoute = {};
    for (final point in allPoints) {
      groupedByRoute.putIfAbsent(point.routeId, () => []).add(point);
    }

    // Convert to TrafficJamRouteModel
    return groupedByRoute.entries.map((entry) {
      final routePoints = entry.value;
      return TrafficJamRouteModel(
        routeId: entry.key,
        routeName: routePoints.first.routeName,
        lineColor: routePoints.first.lineColor,
        lineWidth: routePoints.first.lineWidth,
        description: routePoints.first.description,
        points: routePoints
            .map((p) => TrafficJamPoint(
                  latitude: p.latitude,
                  longitude: p.longitude,
                  orderIndex: p.orderIndex,
                ))
            .toList(),
      );
    }).toList();
  }

  /// Insert a complete route with all its points
  Future<void> insertRoute(TrafficJamRouteModel route) async {
    await batch((batch) {
      for (final point in route.points) {
        batch.insert(
          trafficJams,
          TrafficJamsCompanion.insert(
            routeId: route.routeId,
            routeName: route.routeName,
            latitude: point.latitude,
            longitude: point.longitude,
            orderIndex: point.orderIndex,
            lineColor: Value(route.lineColor),
            lineWidth: Value(route.lineWidth),
            description: Value(route.description),
          ),
        );
      }
    });
  }

  /// Insert multiple routes in a single batch
  Future<void> insertRoutes(List<TrafficJamRouteModel> routes) async {
    await batch((batch) {
      for (final route in routes) {
        for (final point in route.points) {
          batch.insert(
            trafficJams,
            TrafficJamsCompanion.insert(
              routeId: route.routeId,
              routeName: route.routeName,
              latitude: point.latitude,
              longitude: point.longitude,
              orderIndex: point.orderIndex,
              lineColor: Value(route.lineColor),
              lineWidth: Value(route.lineWidth),
              description: Value(route.description),
            ),
          );
        }
      }
    });
  }

  /// Delete all points for a specific route
  Future<int> deleteRoute(int routeId) {
    return (delete(trafficJams)..where((t) => t.routeId.equals(routeId))).go();
  }

  /// Delete all traffic jam data
  Future<int> deleteAll() {
    return delete(trafficJams).go();
  }

  /// Count total number of routes
  Future<int> countRoutes() async {
    final query = selectOnly(trafficJams)
      ..addColumns([trafficJams.routeId])
      ..groupBy([trafficJams.routeId]);
    final result = await query.get();
    return result.length;
  }

  /// Count total number of points across all routes
  Future<int> countPoints() async {
    final countExp = trafficJams.id.count();
    final query = selectOnly(trafficJams)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  /// Watch all routes for real-time updates
  Stream<List<TrafficJamRouteModel>> watchAllRoutes() {
    return (select(trafficJams)
          ..orderBy([
            (t) => OrderingTerm.asc(t.routeId),
            (t) => OrderingTerm.asc(t.orderIndex),
          ]))
        .watch()
        .map((allPoints) {
      // Group points by routeId
      final Map<int, List<TrafficJamEntity>> groupedByRoute = {};
      for (final point in allPoints) {
        groupedByRoute.putIfAbsent(point.routeId, () => []).add(point);
      }

      // Convert to TrafficJamRouteModel
      return groupedByRoute.entries.map((entry) {
        final routePoints = entry.value;
        return TrafficJamRouteModel(
          routeId: entry.key,
          routeName: routePoints.first.routeName,
          lineColor: routePoints.first.lineColor,
          lineWidth: routePoints.first.lineWidth,
          description: routePoints.first.description,
          points: routePoints
              .map((p) => TrafficJamPoint(
                    latitude: p.latitude,
                    longitude: p.longitude,
                    orderIndex: p.orderIndex,
                  ))
              .toList(),
        );
      }).toList();
    });
  }
}
