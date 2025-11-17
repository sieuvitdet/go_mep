import 'package:flutter/material.dart';
import 'package:go_mep_application/common/utils/app_feature.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/data/model/res/temporary_report_marker_model.dart';

/// Callback type for feature actions
typedef FeatureActionCallback = void Function(AppFeature feature, Map<String, dynamic>? params);

/// Handles actions for recognized features
class FeatureActionHandler {
  /// Execute action based on recognized feature
  /// Returns response text to display to user
  static String handleFeature(
    BuildContext context,
    FeatureRecognitionResult result, {
    FeatureActionCallback? onAction,
  }) {
    if (!result.isConfident) {
      return _getUncertainResponse(result);
    }

    // Execute the action
    if (onAction != null) {
      onAction(result.feature, result.parameters);
    } else {
      _executeDefaultAction(context, result.feature);
    }

    // Return response text
    return _getResponseText(result.feature);
  }

  /// Execute default action (navigation, dialog, etc.)
  static void _executeDefaultAction(BuildContext context, AppFeature feature) {
    switch (feature) {
      case AppFeature.reportTrafficJam:
        _handleReportFeature(
          context,
          reportType: ReportType.trafficJam,
          title: 'Báo Tắc Đường',
          message: 'Bạn muốn báo cáo tắc đường tại vị trí hiện tại?',
        );
        break;

      case AppFeature.reportWaterlogging:
        _handleReportFeature(
          context,
          reportType: ReportType.waterlogging,
          title: 'Báo Ngập Nước',
          message: 'Bạn muốn báo cáo ngập nước tại vị trí hiện tại?',
        );
        break;

      case AppFeature.reportAccident:
        _handleReportFeature(
          context,
          reportType: ReportType.accident,
          title: 'Báo Tai Nạn',
          message: 'Bạn muốn báo cáo tai nạn tại vị trí hiện tại?',
        );
        break;

      case AppFeature.findRestaurants:
        // TODO: Implement restaurant search
        _showInfoSnackBar(context, 'Đang tìm kiếm quán ăn gần bạn...');
        break;

      case AppFeature.openRestaurantList:
        // TODO: Navigate to restaurant list screen
        _showInfoSnackBar(context, 'Mở danh sách quán ăn...');
        break;

      case AppFeature.openNotifications:
        // TODO: Navigate to notifications screen
        _showInfoSnackBar(context, 'Mở thông báo...');
        break;

      case AppFeature.openProfile:
        // TODO: Navigate to profile screen
        _showInfoSnackBar(context, 'Mở profile...');
        break;

      case AppFeature.unknown:
        _showInfoSnackBar(context, 'Xin lỗi, tôi chưa hiểu yêu cầu của bạn.');
        break;
    }
  }

  /// Handle report features (Traffic Jam, Waterlogging, Accident)
  static void _handleReportFeature(
    BuildContext context, {
    required ReportType reportType,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Show loading
              _showInfoSnackBar(context, 'Đang lấy vị trí...');

              try {
                final repository = Globals.temporaryReportMarkerRepository;
                if (repository == null) {
                  _showInfoSnackBar(context, 'Lỗi: Repository chưa được khởi tạo');
                  return;
                }

                // Create marker at current location
                final marker = await repository.createReportAtCurrentLocation(
                  reportType: reportType,
                  description: 'Báo cáo từ người dùng',
                );

                // Success message
                _showInfoSnackBar(
                  context,
                  'Đã báo cáo ${reportType.displayName} thành công!\n'
                  'Marker sẽ tự động ẩn sau 1 tiếng.',
                );

                debugPrint('✅ Created report marker: ${marker.toString()}');

                // Optionally refresh map to show new marker
                // You can emit an event here to refresh the map
              } catch (e) {
                debugPrint('❌ Error creating report marker: $e');
                _showInfoSnackBar(
                  context,
                  'Lỗi: Không thể lấy vị trí. Vui lòng bật GPS.',
                );
              }
            },
            child: const Text('Báo cáo'),
          ),
        ],
      ),
    );
  }

  /// Show info snack bar
  static void _showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Get response text for the feature
  static String _getResponseText(AppFeature feature) {
    switch (feature) {
      case AppFeature.reportTrafficJam:
        return 'Đã mở chức năng báo tắc đường. Vui lòng xác nhận vị trí và gửi báo cáo.';
      case AppFeature.reportWaterlogging:
        return 'Đã mở chức năng báo ngập nước. Vui lòng xác nhận vị trí và gửi báo cáo.';
      case AppFeature.reportAccident:
        return 'Đã mở chức năng báo tai nạn. Vui lòng xác nhận vị trí và gửi báo cáo.';
      case AppFeature.findRestaurants:
        return 'Đang tìm kiếm quán ăn gần bạn...';
      case AppFeature.openRestaurantList:
        return 'Đang mở danh sách quán ăn...';
      case AppFeature.openNotifications:
        return 'Đang mở danh sách thông báo...';
      case AppFeature.openProfile:
        return 'Đang mở trang cá nhân...';
      case AppFeature.unknown:
        return 'Xin lỗi, tôi chưa hiểu yêu cầu của bạn. Vui lòng thử lại.';
    }
  }

  /// Get uncertain response when confidence is low
  static String _getUncertainResponse(FeatureRecognitionResult result) {
    if (result.feature == AppFeature.unknown) {
      return 'Xin lỗi, tôi chưa hiểu yêu cầu của bạn.\n\n'
          'Bạn có thể thử:\n'
          '• Báo tắc đường\n'
          '• Báo ngập nước\n'
          '• Báo tai nạn\n'
          '• Tìm quán ăn\n'
          '• Mở thông báo\n'
          '• Mở profile';
    }

    return 'Bạn có muốn ${result.feature.displayName.toLowerCase()} không?\n'
        '(Độ chắc chắn: ${(result.confidence * 100).toStringAsFixed(0)}%)';
  }

  /// Handle multiple features (when input matches multiple features)
  static String handleMultipleFeatures(
    BuildContext context,
    List<FeatureRecognitionResult> results, {
    FeatureActionCallback? onAction,
  }) {
    if (results.isEmpty) {
      return 'Xin lỗi, tôi chưa hiểu yêu cầu của bạn.';
    }

    if (results.length == 1) {
      return handleFeature(context, results.first, onAction: onAction);
    }

    // Multiple features detected - show selection dialog
    _showFeatureSelectionDialog(
      context,
      results: results,
      onAction: onAction,
    );

    return 'Tôi tìm thấy ${results.length} tính năng phù hợp. Vui lòng chọn:';
  }

  /// Show dialog to select from multiple detected features
  static void _showFeatureSelectionDialog(
    BuildContext context, {
    required List<FeatureRecognitionResult> results,
    FeatureActionCallback? onAction,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn tính năng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: results.map((result) {
            return ListTile(
              leading: Icon(_getFeatureIcon(result.feature)),
              title: Text(result.feature.displayName),
              subtitle: Text(
                'Độ chắc chắn: ${(result.confidence * 100).toStringAsFixed(0)}%',
              ),
              onTap: () {
                Navigator.pop(context);
                handleFeature(context, result, onAction: onAction);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  /// Get icon for feature
  static IconData _getFeatureIcon(AppFeature feature) {
    switch (feature) {
      case AppFeature.reportTrafficJam:
        return Icons.traffic;
      case AppFeature.reportWaterlogging:
        return Icons.water_damage;
      case AppFeature.reportAccident:
        return Icons.car_crash;
      case AppFeature.findRestaurants:
        return Icons.search;
      case AppFeature.openRestaurantList:
        return Icons.restaurant_menu;
      case AppFeature.openNotifications:
        return Icons.notifications;
      case AppFeature.openProfile:
        return Icons.person;
      case AppFeature.unknown:
        return Icons.help_outline;
    }
  }
}
