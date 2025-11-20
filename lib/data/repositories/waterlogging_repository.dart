import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// Khởi tạo dữ liệu mẫu từ JSON file (nếu chưa có)
  Future<void> initializeSampleData() async {
    try {
      final count = await countRoutes();
      if (count > 0) {
        debugPrint('ℹ️ Waterlogging data already exists ($count routes)');
        return;
      }

      debugPrint('🔄 Initializing sample waterlogging data from JSON...');

      // Load JSON from assets
      final jsonString = await rootBundle.loadString('assets/json/traffic_jam_example.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      // Parse JSON to WaterloggingRouteModel
      final sampleRoutes = jsonList.map((jsonItem) {
        final List<String> pointStrings = (jsonItem['points'] as List<dynamic>).cast<String>();
        final points = pointStrings.asMap().entries.map((entry) {
          return WaterloggingPoint.fromString(entry.value, entry.key);
        }).toList();

        return WaterloggingRouteModel(
          routeId: jsonItem['routeId'] as int,
          routeName: jsonItem['routeName'] as String,
          lineColor: jsonItem['lineColor'] as String,
          lineWidth: (jsonItem['lineWidth'] as num).toDouble(),
          description: jsonItem['description'] as String,
          points: points,
        );
      }).toList();

      await addRoutes(sampleRoutes);
      debugPrint('✅ Sample waterlogging data initialized: ${sampleRoutes.length} routes');
    } catch (e) {
      debugPrint('❌ WaterloggingRepository.initializeSampleData error: $e');
    }
  }
}
