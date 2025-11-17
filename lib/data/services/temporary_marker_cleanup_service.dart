import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_mep_application/data/repositories/temporary_report_marker_repository.dart';

/// Service that automatically cleans up expired temporary markers
/// Runs periodic cleanup every 5 minutes
class TemporaryMarkerCleanupService {
  final TemporaryReportMarkerRepository _repository;
  Timer? _cleanupTimer;
  bool _isRunning = false;

  /// Cleanup interval (default: 5 minutes)
  final Duration cleanupInterval;

  TemporaryMarkerCleanupService({
    required TemporaryReportMarkerRepository repository,
    this.cleanupInterval = const Duration(minutes: 5),
  }) : _repository = repository;

  /// Start the cleanup service
  void start() {
    if (_isRunning) {
      debugPrint('⚠️ Cleanup service already running');
      return;
    }

    _isRunning = true;
    debugPrint('✅ Starting temporary marker cleanup service');
    debugPrint('   Cleanup interval: ${cleanupInterval.inMinutes} minutes');

    // Run initial cleanup
    _performCleanup();

    // Schedule periodic cleanup
    _cleanupTimer = Timer.periodic(cleanupInterval, (_) {
      _performCleanup();
    });
  }

  /// Stop the cleanup service
  void stop() {
    if (!_isRunning) {
      debugPrint('⚠️ Cleanup service not running');
      return;
    }

    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    _isRunning = false;
    debugPrint('🛑 Stopped temporary marker cleanup service');
  }

  /// Perform cleanup of expired markers
  Future<void> _performCleanup() async {
    try {
      debugPrint('🧹 Running cleanup of expired markers...');

      final expiredCount = await _repository.countExpiredMarkers();
      if (expiredCount == 0) {
        debugPrint('   No expired markers to clean up');
        return;
      }

      final deletedCount = await _repository.deleteExpiredMarkers();
      debugPrint('   Cleaned up $deletedCount expired markers');

      // Log statistics
      final stats = await _repository.getStatistics();
      debugPrint('   Active markers: ${stats['active']}');
      debugPrint('     - Tắc đường: ${stats['trafficJam']}');
      debugPrint('     - Ngập nước: ${stats['waterlogging']}');
      debugPrint('     - Tai nạn: ${stats['accident']}');
    } catch (e) {
      debugPrint('❌ Error during cleanup: $e');
    }
  }

  /// Manually trigger cleanup (useful for testing)
  Future<void> triggerCleanup() async {
    debugPrint('🔧 Manual cleanup triggered');
    await _performCleanup();
  }

  /// Check if service is running
  bool get isRunning => _isRunning;

  /// Dispose the service
  void dispose() {
    stop();
  }
}
