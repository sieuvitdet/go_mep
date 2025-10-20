import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/data/model/req/notification_req_model.dart';
import 'package:go_mep_application/data/model/res/notification_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
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
    // Remove automatic API call from constructor
  }

  Future<void> loadNotifications({bool isLoadMore = false}) async {
    // Prevent concurrent API calls
    if ((!isLoadMore && _isLoading) || (isLoadMore && _isLoadingMore)) {
      return;
    }

    if (isLoadMore && currentPage >= totalPages) return;

    // Set loading states
    if (isLoadMore) {
      _isLoadingMore = true;
      streamLoadMore.set(true);
    } else {
      _isLoading = true;
      streamLoading.set(true);
      currentPage = 1;
      notifications.clear();
      streamError.set(null); // Clear previous errors
    }

    try {
      ResponseModel responseModel = await Repository.getNotifications(
        context,
        NotificationReqModel(
          pageNumber: currentPage,
          pageSize: pageSize,
        ),
      );

      if (responseModel.success ?? false) {
        NotificationResModel notificationRes = NotificationResModel.fromJson(
          responseModel.result ?? {},
        );

        if (notificationRes.data != null) {
          if (isLoadMore) {
            notifications.addAll(notificationRes.data!);
          } else {
            notifications = notificationRes.data!;
            _hasInitialized = true;
          }

          totalPages = notificationRes.metadata?.total ?? 1;
          streamTotalPages.set(totalPages);
          streamNotifications.set(notifications);

          if (isLoadMore) {
            currentPage++;
          }
        }

        // Clear error state on success
        streamError.set(null);
      } else {
        // Handle API failure
        String errorMessage =
            responseModel.message ?? 'Không thể tải thông báo';
        streamError.set(errorMessage);

        // If this is the first load and failed, set empty list
        if (!isLoadMore && !_hasInitialized) {
          streamNotifications.set([]);
        }
      }
    } catch (e) {
      // Handle network errors or exceptions
      String errorMessage = 'Lỗi kết nối mạng. Vui lòng thử lại.';
      streamError.set(errorMessage);

      // If this is the first load and failed, set empty list
      if (!isLoadMore && !_hasInitialized) {
        streamNotifications.set([]);
      }
    } finally {
      // Always reset loading states
      _isLoading = false;
      _isLoadingMore = false;
      streamLoading.set(false);
      streamLoadMore.set(false);
    }
  }

  Future<void> markAllAsRead() async {
    // TODO: Implement mark all as read API call when available
    // For now, update local state
    for (var notification in notifications) {
      notification = NotificationData(
        id: notification.id,
        title: notification.title,
        content: notification.content,
        type: notification.type,
        isRead: true,
        createAt: notification.createAt,
      );
    }
    streamNotifications.set(notifications);
  }

  Future<void> markAsRead(String notificationId) async {
    // TODO: Implement mark as read API call when available
    // For now, update local state
    int index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = NotificationData(
        id: notifications[index].id,
        title: notifications[index].title,
        content: notifications[index].content,
        type: notifications[index].type,
        isRead: true,
        createAt: notifications[index].createAt,
      );
      streamNotifications.set(notifications);
    }
  }

  Future<void> refreshNotifications() async {
    // Cancel any pending debounced calls
    _debounceTimer?.cancel();

    // Use debounce to prevent rapid consecutive refresh calls
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      loadNotifications();
    });
  }

  // Method to initialize data loading (call this from UI when needed)
  void initializeNotifications() {
    if (!_hasInitialized && !_isLoading) {
      loadNotifications();
    }
  }

  // Method to force reload (bypass debounce)
  Future<void> forceRefresh() async {
    _debounceTimer?.cancel();
    await loadNotifications();
  }

  void dispose() {
    _debounceTimer?.cancel();
    streamNotifications.close();
    streamLoading.close();
    streamLoadMore.close();
    streamTotalPages.close();
    streamError.close();
  }
}
