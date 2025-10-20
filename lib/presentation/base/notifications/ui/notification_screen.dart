import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/res/notification_res_model.dart';
import 'package:go_mep_application/presentation/base/notifications/bloc/notification_bloc.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationBloc _bloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = NotificationBloc(context);
    _bloc.initializeNotifications();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _bloc.loadNotifications(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatNotificationTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.getTextColor(context), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CustomText(
          text: 'Thông báo',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.getTextColor(context),
        ),
      ),
      body: StreamBuilder<bool>(
        stream: _bloc.streamLoading,
        builder: (context, loadingSnapshot) {
          if (loadingSnapshot.data == true) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.getTextColor(context),
              ),
            );
          }

          return StreamBuilder<List<NotificationData>>(
            stream: _bloc.streamNotifications,
            builder: (context, snapshot) {
              final notifications = snapshot.data ?? [];

              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 80,
                        color: AppColors.hint,
                      ),
                      Gaps.vGap16,
                      CustomText(
                        text: 'Không có thông báo',
                        fontSize: 16,
                        color: AppColors.hint,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _bloc.refreshNotifications(),
                color: Colors.white,
                backgroundColor: AppColors.getBackgroundCard(context),
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemCount: notifications.length + 1,
                  separatorBuilder: (context, index) {
                    if (index == notifications.length - 1)
                      return const SizedBox();
                    return Gaps.vGap12;
                  },
                  itemBuilder: (context, index) {
                    if (index == notifications.length) {
                      return StreamBuilder<bool>(
                        stream: _bloc.streamLoadMore,
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.getTextColor(context),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      );
                    }

                    final item = notifications[index];
                    return InkWell(
                      onTap: () {
                        if (!(item.isRead ?? false)) {
                          _bloc.markAsRead(item.id ?? '');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.getBackgroundCard(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: 'Thông báo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.getTextColor(context),
                                ),
                                CustomText(
                                  text: _formatNotificationTime(item.createAt),
                                  fontSize: 14,
                                  color: AppColors.hint,
                                ),
                              ],
                            ),
                            Gaps.vGap8,
                            CustomText(
                              text: item.content ?? 'Kết xe ở đâu đường khu chế xuất Tân thuận cấp độ 5 hiện khó có thể đi chuyển. Có thể đi tuyến đường Nguyễn Văn Linh để đỡ kẹt xe',
                              fontSize: 14,
                              color: AppColors.hint,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              height: 1.4,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
