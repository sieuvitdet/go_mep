import 'package:go_mep_application/data/local/database/app_database.dart';
import 'package:go_mep_application/data/model/res/temporary_report_marker_model.dart';
import 'package:geolocator/geolocator.dart';

/// Repository for managing temporary report markers
class TemporaryReportMarkerRepository {
  final AppDatabase _database;

  TemporaryReportMarkerRepository(this._database);

  /// Get all active markers
  Future<List<TemporaryReportMarkerModel>> getAllActiveMarkers() async {
    return await _database.temporaryReportMarkerDao.getAllActiveMarkers();
  }

  /// Get markers by type
  Future<List<TemporaryReportMarkerModel>> getMarkersByType(
      ReportType type) async {
    return await _database.temporaryReportMarkerDao.getMarkersByType(type);
  }

  /// Get marker by ID
  Future<TemporaryReportMarkerModel?> getMarkerById(int id) async {
    return await _database.temporaryReportMarkerDao.getMarkerById(id);
  }

  /// Create a new report marker at current device location
  Future<TemporaryReportMarkerModel> createReportAtCurrentLocation({
    required ReportType reportType,
    String? description,
    String? userReportedBy,
    Duration expiryDuration = const Duration(hours: 1),
  }) async {
    // Get current location
    final position = await _getCurrentPosition();

    // Create marker model
    final marker = TemporaryReportMarkerModel.create(
      id: 0, // Will be auto-generated
      reportType: reportType,
      latitude: position.latitude,
      longitude: position.longitude,
      description: description,
      userReportedBy: userReportedBy,
      expiryDuration: expiryDuration,
    );

    // Insert to database
    final id = await _database.temporaryReportMarkerDao.insertMarker(marker);

    // Return marker with generated ID
    return marker.copyWith(id: id);
  }

  /// Create a report marker at specific location
  Future<TemporaryReportMarkerModel> createReportAtLocation({
    required ReportType reportType,
    required double latitude,
    required double longitude,
    String? description,
    String? userReportedBy,
    Duration expiryDuration = const Duration(hours: 1),
  }) async {
    // Create marker model
    final marker = TemporaryReportMarkerModel.create(
      id: 0, // Will be auto-generated
      reportType: reportType,
      latitude: latitude,
      longitude: longitude,
      description: description,
      userReportedBy: userReportedBy,
      expiryDuration: expiryDuration,
    );

    // Insert to database
    final id = await _database.temporaryReportMarkerDao.insertMarker(marker);

    // Return marker with generated ID
    return marker.copyWith(id: id);
  }

  /// Delete a marker
  Future<void> deleteMarker(int id) async {
    await _database.temporaryReportMarkerDao.deleteMarker(id);
  }

  /// Delete expired markers (cleanup)
  Future<int> deleteExpiredMarkers() async {
    return await _database.temporaryReportMarkerDao.deleteExpiredMarkers();
  }

  /// Delete all markers
  Future<void> deleteAllMarkers() async {
    await _database.temporaryReportMarkerDao.deleteAllMarkers();
  }

  /// Count active markers
  Future<int> countActiveMarkers() async {
    return await _database.temporaryReportMarkerDao.countActiveMarkers();
  }

  /// Count expired markers
  Future<int> countExpiredMarkers() async {
    return await _database.temporaryReportMarkerDao.countExpiredMarkers();
  }

  /// Watch active markers for real-time updates
  Stream<List<TemporaryReportMarkerModel>> watchActiveMarkers() {
    return _database.temporaryReportMarkerDao.watchActiveMarkers();
  }

  /// Get current device position
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Try to open location settings
      await Geolocator.openLocationSettings();
      throw Exception('Vui lòng bật dịch vụ vị trí (GPS)');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Quyền truy cập vị trí bị từ chối');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Open app settings so user can grant permission
      await Geolocator.openAppSettings();
      throw Exception(
          'Quyền truy cập vị trí bị từ chối vĩnh viễn. Vui lòng cấp quyền trong Cài đặt.');
    }

    // Get current position with new LocationSettings API
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  /// Get statistics
  Future<Map<String, int>> getStatistics() async {
    final activeCount = await countActiveMarkers();
    final expiredCount = await countExpiredMarkers();

    final trafficJamCount = (await getMarkersByType(ReportType.trafficJam)).length;
    final waterloggingCount =
        (await getMarkersByType(ReportType.waterlogging)).length;
    final accidentCount = (await getMarkersByType(ReportType.accident)).length;

    return {
      'active': activeCount,
      'expired': expiredCount,
      'trafficJam': trafficJamCount,
      'waterlogging': waterloggingCount,
      'accident': accidentCount,
    };
  }
}
