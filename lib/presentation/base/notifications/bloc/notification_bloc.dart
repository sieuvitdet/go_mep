import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/data/model/res/notification_res_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class NotificationBloc {
  late BuildContext context;

  final streamNotifications = BehaviorSubject<List<NotificationData>>();
  final streamLoading = BehaviorSubject<bool>();
  final streamLoadMore = BehaviorSubject<bool>();
  final streamTotalPages = BehaviorSubject<int>();
  final streamError = BehaviorSubject<String?>();
  final streamUnreadCount = BehaviorSubject<int>();

  int currentPage = 1;
  int pageSize = 10;
  int totalPages = 1;
  List<NotificationData> notifications = [];

  Timer? _debounceTimer;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasInitialized = false;

  NotificationBloc(BuildContext context) {
    this.context = context;
    streamLoading.set(false);
    streamLoadMore.set(false);
    streamTotalPages.set(1);
    streamError.set(null);
    streamUnreadCount.set(0);

    // Watch unread count from database (reactive!)
    _watchUnreadCount();
  }

  /// Watch unread count from database (auto-updates!)
  void _watchUnreadCount() {
    final repository = Globals.notificationRepository;
    if (repository != null) {
      repository.watchUnreadCount().listen((count) {
        streamUnreadCount.set(count);
      });
    }
  }

  /// Load notifications with cache-first strategy
  ///
  /// Strategy:
  /// 1. Load from cache first (instant UI)
  /// 2. Fetch from API in background
  /// 3. Update cache with fresh data
  /// 4. If offline, use cached data only
  Future<void> loadNotifications({bool isLoadMore = false, bool forceRefresh = false}) async {
    // Prevent concurrent API calls
    if ((!isLoadMore && _isLoading) || (isLoadMore && _isLoadingMore)) {
      return;
    }

    if (isLoadMore && currentPage >= totalPages) return;

    final repository = Globals.notificationRepository;
    if (repository == null) {
      debugPrint('❌ NotificationRepository not initialized');
      return;
    }

    // Set loading states
    if (isLoadMore) {
      _isLoadingMore = true;
      streamLoadMore.set(true);
    } else {
      _isLoading = true;
      streamLoading.set(true);
      currentPage = 1;
      streamError.set(null);
    }

    try {
      // Step 1: Load from cache first (if not force refresh)
      if (!isLoadMore && !forceRefresh) {
        final cached = await repository.getCachedNotifications();
        if (cached.isNotEmpty) {
          notifications = cached;
          streamNotifications.set(notifications);
          _hasInitialized = true;
          debugPrint('📱 Loaded ${cached.length} notifications from cache');
        }
      }

      // Step 2: Fetch from API
      final apiNotifications = await repository.getNotifications(
        context: context,
        page: currentPage,
        pageSize: pageSize,
        forceRefresh: forceRefresh,
      );

      if (apiNotifications.isNotEmpty) {
        if (isLoadMore) {
          notifications.addAll(apiNotifications);
        } else {
          notifications = apiNotifications;
          _hasInitialized = true;
        }

        // Update total pages (estimate based on loaded data)
        totalPages = (notifications.length / pageSize).ceil() + 1;
        streamTotalPages.set(totalPages);
        streamNotifications.set(notifications);

        if (isLoadMore) {
          currentPage++;
        }

        streamError.set(null);
        debugPrint('✅ Loaded ${apiNotifications.length} notifications from API');
      } else {
        // No data from API, use cache
        if (!_hasInitialized) {
          streamNotifications.set([]);
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading notifications: $e');

      // On error, try to use cache
      if (!_hasInitialized && !isLoadMore) {
        final cached = await repository.getCachedNotifications();
        if (cached.isNotEmpty) {
          notifications = cached;
          streamNotifications.set(notifications);
          _hasInitialized = true;
          streamError.set('Hiển thị dữ liệu offline');
        } else {
          streamError.set('Lỗi kết nối mạng. Vui lòng thử lại.');
          streamNotifications.set([]);
        }
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      streamLoading.set(false);
      streamLoadMore.set(false);
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final repository = Globals.notificationRepository;
    if (repository == null) return;

    try {
      // Update local cache
      await repository.markAllAsRead();

      // Update local state
      for (var i = 0; i < notifications.length; i++) {
        final n = notifications[i];
        notifications[i] = NotificationData(
          id: n.id,
          userId: n.userId,
          notificationId: n.notificationId,
          title: n.title,
          content: n.content,
          targetKey: n.targetKey,
          targetData: n.targetData,
          isRead: true,
          createAt: n.createAt,
          readAt: DateTime.now(),
          deliveredAt: n.deliveredAt,
          type: n.type,
          priority: n.priority,
        );
      }

      streamNotifications.set(notifications);
      debugPrint('✅ Marked all notifications as read');
    } catch (e) {
      debugPrint('❌ Error marking all as read: $e');
    }
  }

  /// Mark single notification as read
  Future<void> markAsRead(String notificationId) async {
    final repository = Globals.notificationRepository;
    if (repository == null) return;

    try {
      // Update local cache
      await repository.markAsRead(notificationId);

      // Update local state
      int index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final n = notifications[index];
        notifications[index] = NotificationData(
          id: n.id,
          userId: n.userId,
          notificationId: n.notificationId,
          title: n.title,
          content: n.content,
          targetKey: n.targetKey,
          targetData: n.targetData,
          isRead: true,
          createAt: n.createAt,
          readAt: DateTime.now(),
          deliveredAt: n.deliveredAt,
          type: n.type,
          priority: n.priority,
        );

        streamNotifications.set(notifications);
        debugPrint('✅ Marked notification $notificationId as read');
      }
    } catch (e) {
      debugPrint('❌ Error marking notification as read: $e');
    }
  }

  /// Refresh notifications (with debounce)
  Future<void> refreshNotifications() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      loadNotifications(forceRefresh: true);
    });
  }

  /// Initialize notifications (call from UI)
  void initializeNotifications() {
    if (!_hasInitialized && !_isLoading) {
      loadNotifications();
    }
  }

  /// Force refresh (bypass debounce)
  Future<void> forceRefresh() async {
    _debounceTimer?.cancel();
    await loadNotifications(forceRefresh: true);
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    final repository = Globals.notificationRepository;
    if (repository == null) return 0;

    try {
      return await repository.getUnreadCount();
    } catch (e) {
      debugPrint('❌ Error getting unread count: $e');
      return 0;
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
    streamNotifications.close();
    streamLoading.close();
    streamLoadMore.close();
    streamTotalPages.close();
    streamError.close();
    streamUnreadCount.close();
  }
}
