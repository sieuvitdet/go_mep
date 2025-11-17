import 'package:go_mep_application/data/local/database/app_database.dart';
import 'package:go_mep_application/data/model/res/traffic_jam_route_model.dart';

/// Repository for managing traffic jam routes
/// Provides a clean API for accessing traffic jam data from the database
class TrafficJamRepository {
  final AppDatabase _database;

  TrafficJamRepository(this._database);

  /// Get all traffic jam routes from the database
  Future<List<TrafficJamRouteModel>> getAllRoutes() async {
    return await _database.trafficJamDao.getAllRoutes();
  }

  /// Get a specific route by its ID
  Future<TrafficJamRouteModel?> getRouteById(int routeId) async {
    final routes = await _database.trafficJamDao.getAllRoutes();
    try {
      return routes.firstWhere((route) => route.routeId == routeId);
    } catch (e) {
      return null;
    }
  }

  /// Add a new traffic jam route
  Future<void> addRoute(TrafficJamRouteModel route) async {
    await _database.trafficJamDao.insertRoute(route);
  }

  /// Add multiple traffic jam routes at once
  Future<void> addRoutes(List<TrafficJamRouteModel> routes) async {
    await _database.trafficJamDao.insertRoutes(routes);
  }

  /// Delete a specific route
  Future<void> deleteRoute(int routeId) async {
    await _database.trafficJamDao.deleteRoute(routeId);
  }

  /// Clear all traffic jam routes
  Future<void> clearAll() async {
    await _database.trafficJamDao.deleteAll();
  }

  /// Get count of routes
  Future<int> countRoutes() async {
    return await _database.trafficJamDao.countRoutes();
  }

  /// Get count of total points
  Future<int> countPoints() async {
    return await _database.trafficJamDao.countPoints();
  }

  /// Watch routes for real-time updates
  Stream<List<TrafficJamRouteModel>> watchAllRoutes() {
    return _database.trafficJamDao.watchAllRoutes();
  }

  /// Initialize with sample data if database is empty
  /// This method should be called once during app initialization
  Future<void> initializeSampleData() async {
    final count = await countRoutes();
    if (count == 0) {
      // Add sample traffic jam routes
      final sampleRoutes = _createSampleRoutes();
      await addRoutes(sampleRoutes);
      print('✅ Initialized ${sampleRoutes.length} sample traffic jam routes');
    } else {
      print('ℹ️ Traffic jam database already has $count routes');
    }
  }

  /// Create sample traffic jam routes for testing
  /// This data will be replaced when user imports JSON
  List<TrafficJamRouteModel> _createSampleRoutes() {
    return [
      // Sample Route 1: Sample traffic area
      TrafficJamRouteModel(
        routeId: 1,
        routeName: 'Tắc Đường Mẫu 1',
        lineColor: '#FF5722', // Deep Orange
        lineWidth: 6.0,
        description: 'Tuyến đường tắc nghẽn khu vực 1 - Dữ liệu mẫu',
        points: [
          TrafficJamPoint.fromString('10.737973, 106.730258', 0),
          TrafficJamPoint.fromString('10.738234, 106.731456', 1),
          TrafficJamPoint.fromString('10.738891, 106.732012', 2),
          TrafficJamPoint.fromString('10.739456, 106.732789', 3),
        ],
      ),

      // Sample Route 2: Another sample traffic area
      TrafficJamRouteModel(
        routeId: 2,
        routeName: 'Tắc Đường Mẫu 2',
        lineColor: '#F44336', // Red
        lineWidth: 7.0,
        description: 'Tuyến đường tắc nghẽn khu vực 2 - Dữ liệu mẫu',
        points: [
          TrafficJamPoint.fromString('10.740123, 106.729456', 0),
          TrafficJamPoint.fromString('10.740789, 106.730123', 1),
          TrafficJamPoint.fromString('10.741234, 106.730891', 2),
          TrafficJamPoint.fromString('10.741890, 106.731567', 3),
          TrafficJamPoint.fromString('10.742345, 106.732234', 4),
        ],
      ),

      // Sample Route 3: Third sample traffic area
      TrafficJamRouteModel(
        routeId: 3,
        routeName: 'Tắc Đường Mẫu 3',
        lineColor: '#E91E63', // Pink
        lineWidth: 5.0,
        description: 'Tuyến đường tắc nghẽn khu vực 3 - Dữ liệu mẫu',
        points: [
          TrafficJamPoint.fromString('10.735678, 106.728901', 0),
          TrafficJamPoint.fromString('10.736123, 106.729567', 1),
          TrafficJamPoint.fromString('10.736789, 106.730234', 2),
        ],
      ),
    ];
  }

  /// Import routes from JSON data
  /// Expected format: List<Map<String, dynamic>> with TrafficJamRouteModel structure
  Future<void> importFromJson(List<Map<String, dynamic>> jsonData) async {
    final routes = jsonData
        .map((json) => TrafficJamRouteModel.fromJson(json))
        .toList();

    // Clear existing data before import
    await clearAll();

    // Import new data
    await addRoutes(routes);

    print('✅ Imported ${routes.length} traffic jam routes from JSON');
  }

  /// Export all routes to JSON format
  Future<List<Map<String, dynamic>>> exportToJson() async {
    final routes = await getAllRoutes();
    return routes.map((route) => route.toJson()).toList();
  }
}
