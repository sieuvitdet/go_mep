import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/res/notification_res_model.dart';

/// Custom notification popup dialog widget
/// Displays notification details in a popup dialog
class NotificationPopupDialog extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback? onClose;
  final VoidCallback? onMarkAsRead;

  const NotificationPopupDialog({
    super.key,
    required this.notification,
    this.onClose,
    this.onMarkAsRead,
  });

  /// Show notification popup dialog
  static Future<void> show(
    BuildContext context, {
    required NotificationData notification,
    VoidCallback? onMarkAsRead,
    bool barrierDismissible = true,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => NotificationPopupDialog(
        notification: notification,
        onMarkAsRead: onMarkAsRead,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.getTextColor(context).withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: 'Thông báo',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getTextColor(context),
                    ),
                  ),
                  InkWell(
                    onTap: onClose,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.getTextColor(context).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.getTextColor(context),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notification icon and title
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientEnd,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Gaps.vGap16,

                  // Title
                  CustomText(
                    text: notification.title ?? 'Thông báo',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextColor(context),
                  ),
                  Gaps.vGap12,

                  // Content
                  CustomText(
                    text: notification.content ?? '',
                    fontSize: 15,
                    color: AppColors.getTextColor(context).withValues(alpha: 0.7),
                    maxLines: 10,
                  ),
                  Gaps.vGap16,

                  // Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.getTextColor(context).withValues(alpha: 0.5),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      CustomText(
                        text: _formatTime(notification.createAt),
                        fontSize: 13,
                        color: AppColors.getTextColor(context).withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.getTextColor(context).withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Mark as read button
                  if (!(notification.isRead ?? false)) ...[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onMarkAsRead?.call();
                          onClose?.call();
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.getTextColor(context).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomText(
                              text: 'Đánh dấu đã đọc',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getTextColor(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],

                  // Close button
                  Expanded(
                    child: InkWell(
                      onTap: onClose,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.gradientStart,
                              AppColors.gradientEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Đóng',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type?.toLowerCase()) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 1) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inHours == 1) {
      return '1 giờ trước';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
