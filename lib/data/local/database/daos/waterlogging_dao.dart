import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/waterlogging_table.dart';
import 'package:go_mep_application/data/model/res/waterlogging_route_model.dart';

part 'waterlogging_dao.g.dart';

@DriftAccessor(tables: [Waterloggings])
class WaterloggingDao extends DatabaseAccessor<AppDatabase>
    with _$WaterloggingDaoMixin {
  WaterloggingDao(AppDatabase db) : super(db);

  /// Lấy tất cả các điểm theo routeId
  Future<List<WaterloggingEntity>> getPointsByRouteId(int routeId) {
    return (select(waterloggings)
          ..where((tbl) => tbl.routeId.equals(routeId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]))
        .get();
  }

  /// Lấy tất cả các routes (nhóm theo routeId)
  Future<List<WaterloggingRouteModel>> getAllRoutes() async {
    final allPoints = await select(waterloggings).get();

    // Nhóm các điểm theo routeId
    final Map<int, List<WaterloggingEntity>> groupedPoints = {};
    for (var point in allPoints) {
      if (!groupedPoints.containsKey(point.routeId)) {
        groupedPoints[point.routeId] = [];
      }
      groupedPoints[point.routeId]!.add(point);
    }

    // Convert sang WaterloggingRouteModel
    final routes = <WaterloggingRouteModel>[];
    for (var entry in groupedPoints.entries) {
      final routeId = entry.key;
      final points = entry.value;
      points.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      if (points.isNotEmpty) {
        routes.add(WaterloggingRouteModel(
          routeId: routeId,
          routeName: points.first.routeName ?? 'Route $routeId',
          points: points
              .map((p) => WaterloggingPoint(
                    latitude: p.latitude,
                    longitude: p.longitude,
                    orderIndex: p.orderIndex,
                  ))
              .toList(),
          lineColor: points.first.lineColor,
          lineWidth: points.first.lineWidth,
          description: points.first.description,
        ));
      }
    }

    return routes;
  }

  /// Thêm một route hoàn chỉnh
  Future<void> insertRoute(WaterloggingRouteModel route) async {
    await batch((batch) {
      for (var point in route.points) {
        batch.insert(
          waterloggings,
          WaterloggingsCompanion.insert(
            routeId: route.routeId,
            routeName: Value(route.routeName),
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

  /// Thêm nhiều routes
  Future<void> insertRoutes(List<WaterloggingRouteModel> routes) async {
    for (var route in routes) {
      await insertRoute(route);
    }
  }

  /// Xóa route theo routeId
  Future<int> deleteRoute(int routeId) {
    return (delete(waterloggings)
          ..where((tbl) => tbl.routeId.equals(routeId)))
        .go();
  }

  /// Xóa tất cả dữ liệu
  Future<int> deleteAll() {
    return delete(waterloggings).go();
  }

  /// Đếm số lượng routes
  Future<int> countRoutes() async {
    final result = await customSelect(
      'SELECT COUNT(DISTINCT route_id) as count FROM waterlogging',
      readsFrom: {waterloggings},
    ).getSingle();
    return result.read<int>('count');
  }

  /// Đếm tổng số điểm
  Future<int> countPoints() async {
    final count = await (selectOnly(waterloggings)
          ..addColumns([waterloggings.id.count()]))
        .getSingle();
    return count.read(waterloggings.id.count()) ?? 0;
  }

  /// Watch tất cả routes (reactive stream)
  Stream<List<WaterloggingRouteModel>> watchAllRoutes() {
    return select(waterloggings).watch().asyncMap((points) async {
      // Nhóm các điểm theo routeId
      final Map<int, List<WaterloggingEntity>> groupedPoints = {};
      for (var point in points) {
        if (!groupedPoints.containsKey(point.routeId)) {
          groupedPoints[point.routeId] = [];
        }
        groupedPoints[point.routeId]!.add(point);
      }

      // Convert sang WaterloggingRouteModel
      final routes = <WaterloggingRouteModel>[];
      for (var entry in groupedPoints.entries) {
        final routeId = entry.key;
        final routePoints = entry.value;
        routePoints.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        if (routePoints.isNotEmpty) {
          routes.add(WaterloggingRouteModel(
            routeId: routeId,
            routeName: routePoints.first.routeName ?? 'Route $routeId',
            points: routePoints
                .map((p) => WaterloggingPoint(
                      latitude: p.latitude,
                      longitude: p.longitude,
                      orderIndex: p.orderIndex,
                    ))
                .toList(),
            lineColor: routePoints.first.lineColor,
            lineWidth: routePoints.first.lineWidth,
            description: routePoints.first.description,
          ));
        }
      }

      return routes;
    });
  }
}
