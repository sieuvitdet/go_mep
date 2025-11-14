import 'package:flutter/material.dart';
import 'app_database.dart';
import '../../repositories/notification_repository.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/places_repository.dart';

/// Service for maintaining database health
///
/// Responsibilities:
/// - Clean up old cached data
/// - Vacuum database to reclaim space
/// - Monitor database size
/// - Schedule periodic maintenance
class DatabaseMaintenanceService {
  final AppDatabase _database;
  final NotificationRepository _notificationRepo;
  final UserRepository _userRepo;
  final PlacesRepository _placesRepo;

  DatabaseMaintenanceService({
    required AppDatabase database,
    required NotificationRepository notificationRepo,
    required UserRepository userRepo,
    required PlacesRepository placesRepo,
  })  : _database = database,
        _notificationRepo = notificationRepo,
        _userRepo = userRepo,
        _placesRepo = placesRepo;

  /// Perform full database maintenance
  ///
  /// Should be called on app start (in background)
  Future<void> performMaintenance() async {
    try {
      debugPrint('🔧 Starting database maintenance...');

      // 1. Clean up old notifications (keep last 30 days)
      await _cleanupNotifications();

      // 2. Clean up old places (keep last 7 days)
      await _cleanupPlaces();

      // 3. Vacuum database to reclaim space
      await _vacuumDatabase();

      // 4. Log database stats
      await _logDatabaseStats();

      debugPrint('✅ Database maintenance completed successfully');
    } catch (e) {
      debugPrint('❌ Database maintenance failed: $e');
    }
  }

  /// Clean up old notifications
  Future<void> _cleanupNotifications() async {
    try {
      // Delete notifications older than 30 days
      await _notificationRepo.cleanupOldNotifications();

      // Keep only latest 1000 notifications
      await _notificationRepo.keepLatestNotifications(1000);

      debugPrint('🧹 Cleaned up old notifications');
    } catch (e) {
      debugPrint('❌ Failed to clean notifications: $e');
    }
  }

  /// Clean up old places
  Future<void> _cleanupPlaces() async {
    try {
      // Delete places older than 7 days
      await _placesRepo.cleanupOldPlaces();

      debugPrint('🧹 Cleaned up old places');
    } catch (e) {
      debugPrint('❌ Failed to clean places: $e');
    }
  }

  /// Vacuum database to reclaim space
  Future<void> _vacuumDatabase() async {
    try {
      await _database.customStatement('VACUUM');
      debugPrint('🗜️ Database vacuumed');
    } catch (e) {
      debugPrint('❌ Failed to vacuum database: $e');
    }
  }

  /// Log database statistics
  Future<void> _logDatabaseStats() async {
    try {
      final notificationCount = await _notificationRepo.getUnreadCount();
      final placesCount = await _placesRepo.getCachedPlacesCount();
      final hasUser = await _userRepo.hasUserCache();

      debugPrint('📊 Database Stats:');
      debugPrint('   - Unread notifications: $notificationCount');
      debugPrint('   - Cached places: $placesCount');
      debugPrint('   - User cached: $hasUser');
    } catch (e) {
      debugPrint('❌ Failed to log database stats: $e');
    }
  }

  /// Clear all cache (useful for logout or troubleshooting)
  Future<void> clearAllCache() async {
    try {
      debugPrint('🗑️ Clearing all cache...');

      await _notificationRepo.clearCache();
      await _placesRepo.clearCache();
      await _userRepo.clearCache();

      await _vacuumDatabase();

      debugPrint('✅ All cache cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear cache: $e');
    }
  }

  /// Clear cache for specific feature
  Future<void> clearCache(CacheType type) async {
    try {
      switch (type) {
        case CacheType.notifications:
          await _notificationRepo.clearCache();
          debugPrint('🗑️ Notifications cache cleared');
          break;
        case CacheType.places:
          await _placesRepo.clearCache();
          debugPrint('🗑️ Places cache cleared');
          break;
        case CacheType.user:
          await _userRepo.clearCache();
          debugPrint('🗑️ User cache cleared');
          break;
      }
    } catch (e) {
      debugPrint('❌ Failed to clear $type cache: $e');
    }
  }

  /// Get database file size (useful for monitoring)
  Future<int?> getDatabaseSize() async {
    try {
      // Query database page count and page size
      final pageCountResult = await _database.customSelect(
        'PRAGMA page_count',
      ).getSingle();

      final pageSizeResult = await _database.customSelect(
        'PRAGMA page_size',
      ).getSingle();

      final pageCount = pageCountResult.data['page_count'] as int?;
      final pageSize = pageSizeResult.data['page_size'] as int?;

      if (pageCount != null && pageSize != null) {
        final sizeInBytes = pageCount * pageSize;
        final sizeInMB = sizeInBytes / (1024 * 1024);

        debugPrint('💾 Database size: ${sizeInMB.toStringAsFixed(2)} MB');
        return sizeInBytes;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Failed to get database size: $e');
      return null;
    }
  }

  /// Check if maintenance is needed
  Future<bool> isMaintenanceNeeded() async {
    try {
      // Check if database is larger than 50 MB
      final size = await getDatabaseSize();
      if (size != null && size > 50 * 1024 * 1024) {
        return true;
      }

      // Check if we have too many notifications
      final notificationCount = await _database.notificationDao.getCount();
      if (notificationCount > 1000) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Failed to check maintenance status: $e');
      return false;
    }
  }

  /// Schedule periodic maintenance (call this on app start)
  Future<void> schedulePeriodicMaintenance() async {
    // Run maintenance in background after 5 seconds
    Future.delayed(const Duration(seconds: 5), () async {
      final needsMaintenance = await isMaintenanceNeeded();

      if (needsMaintenance) {
        debugPrint('🔔 Maintenance needed, starting...');
        await performMaintenance();
      } else {
        debugPrint('✅ No maintenance needed');
      }
    });
  }
}

/// Cache type enum for selective cache clearing
enum CacheType {
  notifications,
  places,
  user,
}
