import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service for handling local notifications
class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _requestAndroidPermissions();
    }

    _isInitialized = true;
    debugPrint('✅ LocalNotificationService initialized');
  }

  /// Request notification permissions for Android 13+
  Future<void> _requestAndroidPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      debugPrint('✅ Android notification permissions requested');
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle navigation or other actions here
  }

  /// Show a report success notification
  Future<void> showReportSuccessNotification({
    required String reportType,
    required double latitude,
    required double longitude,
  }) async {
    if (!_isInitialized) {
      debugPrint('❌ LocalNotificationService not initialized');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'report_channel',
      'Báo cáo giao thông',
      channelDescription: 'Thông báo về báo cáo giao thông',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _notifications.show(
      id,
      'Báo cáo $reportType thành công!',
      'Vị trí: ${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}\n'
      'Thông tin sẽ tự động xóa sau 1 tiếng.',
      notificationDetails,
      payload: 'report_$reportType',
    );

    debugPrint('✅ Showed local notification for $reportType');
  }

  /// Show a generic notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      debugPrint('❌ LocalNotificationService not initialized');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      'Thông báo chung',
      channelDescription: 'Thông báo chung của ứng dụng',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Cancel a specific notification
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}
