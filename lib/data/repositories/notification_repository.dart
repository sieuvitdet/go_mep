import 'package:flutter/material.dart';
import '../local/database/app_database.dart';
import '../local/database/daos/notification_dao.dart';
import '../model/req/notification_req_model.dart';
import '../model/res/notification_res_model.dart';
import '../../net/repository/repository.dart';

/// Repository for managing notifications with cache-first strategy
///
/// Strategy:
/// 1. Always try to load from local cache first (instant UI)
/// 2. Fetch from API in background
/// 3. Update cache with fresh data
/// 4. If offline, use cached data only
class NotificationRepository {
  final NotificationDao _notificationDao;

  NotificationRepository(this._notificationDao);

  /// Watch all notifications (reactive stream that auto-updates)
  Stream<List<NotificationEntity>> watchNotifications() {
    return _notificationDao.watchAllNotifications();
  }

  /// Watch unread notification count
  Stream<int> watchUnreadCount() {
    return _notificationDao.watchUnreadCount();
  }

  /// Get cached notifications (instant, no network)
  Future<List<NotificationData>> getCachedNotifications() async {
    final entities = await _notificationDao.getAllNotifications();
    return entities.map(_entityToModel).toList();
  }

  /// Get notifications with pagination (cache-first strategy)
  Future<List<NotificationData>> getNotifications({
    required BuildContext context,
    required int page,
    required int pageSize,
    bool forceRefresh = false,
  }) async {
    // If not forcing refresh, try cache first
    if (!forceRefresh) {
      final cached = await _notificationDao.getNotifications(
        page: page,
        pageSize: pageSize,
      );

      if (cached.isNotEmpty) {
        // Return cached data immediately
        return cached.map(_entityToModel).toList();
      }
    }

    // Fetch from API
    try {
      final response = await Repository.getNotifications(
        context,
        NotificationReqModel(pageNumber: page, pageSize: pageSize),
      );

      // Parse response
      if (response != null && response.result != null) {
        final resModel = NotificationResModel.fromJson(response.result);

        if (resModel.data != null && resModel.data!.isNotEmpty) {
          // Cache the new data
          await cacheNotifications(resModel.data!);
          return resModel.data!;
        }
      }

      // If API call failed or returned no data, return cached
      return await getCachedNotifications();
    } catch (e) {
      debugPrint('Error fetching notifications from API: $e');
      // On error, return cached data
      return await getCachedNotifications();
    }
  }

  /// Fetch fresh notifications from API and update cache
  Future<NotificationResModel?> fetchFreshNotifications({
    required BuildContext context,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await Repository.getNotifications(
        context,
        NotificationReqModel(pageNumber: page, pageSize: pageSize),
      );

      if (response != null && response.result != null) {
        final resModel = NotificationResModel.fromJson(response.result);

        if (resModel.data != null && resModel.data!.isNotEmpty) {
          // Update cache
          await cacheNotifications(resModel.data!);
        }

        return resModel;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching fresh notifications: $e');
      return null;
    }
  }

  /// Cache notifications to local database
  Future<void> cacheNotifications(List<NotificationData> notifications) async {
    final entities = notifications.map(_modelToEntity).toList();
    await _notificationDao.insertNotifications(entities);
  }

  /// Mark notification as read
  Future<void> markAsRead(String id) async {
    await _notificationDao.markAsRead(id);
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    await _notificationDao.markAllAsRead();
  }

  /// Delete notification
  Future<void> deleteNotification(String id) async {
    await _notificationDao.deleteNotification(id);
  }

  /// Clean up old notifications (keep last 30 days)
  Future<void> cleanupOldNotifications() async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    await _notificationDao.deleteOlderThan(thirtyDaysAgo);
  }

  /// Keep only latest N notifications
  Future<void> keepLatestNotifications(int count) async {
    await _notificationDao.keepLatest(count);
  }

  /// Clear all cached notifications
  Future<void> clearCache() async {
    await _notificationDao.clearAll();
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    final unread = await _notificationDao.getUnreadNotifications();
    return unread.length;
  }

  // Helper methods to convert between Entity and Model

  NotificationData _entityToModel(NotificationEntity entity) {
    return NotificationData(
      id: entity.id,
      userId: entity.userId,
      notificationId: entity.notificationId,
      title: entity.title,
      content: entity.content,
      targetKey: entity.targetKey,
      targetData: entity.targetData,
      isRead: entity.isRead,
      createAt: entity.createAt,
      readAt: entity.readAt,
      deliveredAt: entity.deliveredAt,
      type: entity.type,
      priority: entity.priority,
    );
  }

  NotificationEntity _modelToEntity(NotificationData model) {
    return NotificationEntity(
      id: model.id ?? '',
      userId: model.userId ?? '',
      notificationId: model.notificationId,
      title: model.title ?? '',
      content: model.content ?? '',
      targetKey: model.targetKey,
      targetData: model.targetData,
      isRead: model.isRead ?? false,
      createAt: model.createAt ?? DateTime.now(),
      readAt: model.readAt,
      deliveredAt: model.deliveredAt,
      type: model.type,
      priority: model.priority,
    );
  }
}
