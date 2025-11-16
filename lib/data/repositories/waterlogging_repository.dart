import 'package:flutter/material.dart';
import 'package:go_mep_application/data/local/database/app_database.dart';
import 'package:go_mep_application/data/model/res/waterlogging_route_model.dart';

/// Repository quản lý cache cho waterlogging routes
/// Strategy: Local-only (không có API call)
class WaterloggingRepository {
  final AppDatabase _database;

  WaterloggingRepository(this._database);

  /// Lấy tất cả routes từ cache
  Future<List<WaterloggingRouteModel>> getAllRoutes() async {
    try {
      return await _database.waterloggingDao.getAllRoutes();
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.getAllRoutes error: $e');
      return [];
    }
  }

  /// Lấy route theo ID
  Future<WaterloggingRouteModel?> getRouteById(int routeId) async {
    try {
      final allRoutes = await _database.waterloggingDao.getAllRoutes();
      return allRoutes.firstWhere(
        (route) => route.routeId == routeId,
        orElse: () => throw Exception('Route not found'),
      );
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.getRouteById error: $e');
      return null;
    }
  }

  /// Thêm route mới
  Future<void> addRoute(WaterloggingRouteModel route) async {
    try {
      await _database.waterloggingDao.insertRoute(route);
      debugPrint('✅ Added waterlogging route: ${route.routeName}');
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.addRoute error: $e');
      rethrow;
    }
  }

  /// Thêm nhiều routes
  Future<void> addRoutes(List<WaterloggingRouteModel> routes) async {
    try {
      await _database.waterloggingDao.insertRoutes(routes);
      debugPrint('✅ Added ${routes.length} waterlogging routes');
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.addRoutes error: $e');
      rethrow;
    }
  }

  /// Xóa route
  Future<void> deleteRoute(int routeId) async {
    try {
      final count = await _database.waterloggingDao.deleteRoute(routeId);
      debugPrint('✅ Deleted $count waterlogging points from route $routeId');
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.deleteRoute error: $e');
      rethrow;
    }
  }

  /// Xóa tất cả routes
  Future<void> clearAll() async {
    try {
      final count = await _database.waterloggingDao.deleteAll();
      debugPrint('✅ Cleared $count waterlogging points');
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.clearAll error: $e');
      rethrow;
    }
  }

  /// Đếm số routes
  Future<int> countRoutes() async {
    try {
      return await _database.waterloggingDao.countRoutes();
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.countRoutes error: $e');
      return 0;
    }
  }

  /// Đếm tổng số điểm
  Future<int> countPoints() async {
    try {
      return await _database.waterloggingDao.countPoints();
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.countPoints error: $e');
      return 0;
    }
  }

  /// Watch tất cả routes (reactive)
  Stream<List<WaterloggingRouteModel>> watchAllRoutes() {
    return _database.waterloggingDao.watchAllRoutes();
  }

  /// Khởi tạo dữ liệu mẫu (nếu chưa có)
  Future<void> initializeSampleData() async {
    try {
      final count = await countRoutes();
      if (count > 0) {
        debugPrint('ℹ️ Waterlogging data already exists ($count routes)');
        return;
      }

      debugPrint('🔄 Initializing sample waterlogging data...');

      final sampleRoutes = [
        // Route 1
        WaterloggingRouteModel(
          routeId: 1,
          routeName: 'Đường Ngập 1',
          lineColor: '#2196F3', // Xanh dương
          lineWidth: 5.0,
          description: 'Tuyến đường ngập úng khu vực 1',
          points: [
            WaterloggingPoint.fromString('10.737973, 106.730258', 0),
            WaterloggingPoint.fromString('10.738552, 106.730162', 1),
            WaterloggingPoint.fromString('10.740218, 106.729893', 2),
            WaterloggingPoint.fromString('10.741664, 106.729700', 3),
            WaterloggingPoint.fromString('10.743178, 106.729481', 4),
          ],
        ),
        // Route 2
        WaterloggingRouteModel(
          routeId: 2,
          routeName: 'Đường Ngập 2',
          lineColor: '#2196F3', // Xanh dương
          lineWidth: 5.0,
          description: 'Tuyến đường ngập úng khu vực 2',
          points: [
            WaterloggingPoint.fromString('10.752841, 106.733050', 0),
            WaterloggingPoint.fromString('10.753125, 106.739303', 1),
            WaterloggingPoint.fromString('10.753597, 106.741035', 2),
          ],
        ),
        // Route 3
        WaterloggingRouteModel(
          routeId: 3,
          routeName: 'Đường Ngập 3',
          lineColor: '#2196F3', // Xanh dương
          lineWidth: 5.0,
          description: 'Tuyến đường ngập úng khu vực 3',
          points: [
            WaterloggingPoint.fromString('10.755865, 106.721266', 0),
            WaterloggingPoint.fromString('10.753904, 106.720087', 1),
            WaterloggingPoint.fromString('10.753125, 106.719534', 2),
            WaterloggingPoint.fromString('10.752227, 106.717995', 3),
            WaterloggingPoint.fromString('10.751872, 106.713594', 4),
          ],
        ),
      ];

      await addRoutes(sampleRoutes);
      debugPrint('✅ Sample waterlogging data initialized: ${sampleRoutes.length} routes');
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.initializeSampleData error: $e');
    }
  }
}
