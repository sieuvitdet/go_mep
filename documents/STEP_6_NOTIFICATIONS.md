# Step 6: Notification System Implementation

## Overview
This step implements a comprehensive notification system that displays user notifications with pagination, pull-to-refresh, read/unread status, badge counters, and proper time formatting. The system follows the BLoC pattern for state management and provides a smooth user experience.

## Duration
**3-4 days**

## Status
**✓ Completed**

## Dependencies
- Step 1: Project Setup (completed)
- Step 2: Architecture & Design System (completed)
- Step 3: Network Layer & API Integration (completed)
- Step 5: Home Screen & Main Navigation (completed)

## Objectives
- Build notification list screen
- Implement pagination with load more
- Add pull-to-refresh functionality
- Create read/unread status indicators
- Implement notification badge counter
- Add time formatting (relative time)
- Handle empty states
- Implement loading states
- Add notification interactions

---

## Tasks Completed

### 1. Notification Screen UI

#### Notification Screen (presentation/base/notifications/ui/notification_screen.dart):
```dart
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationBloc bloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = NotificationBloc(context);
    bloc.getNotifications();

    // Pagination listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadMoreNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: () => bloc.markAllAsRead(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await bloc.refreshNotifications();
        },
        child: StreamBuilder<List<NotificationData>>(
          stream: bloc.streamNotifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                (snapshot.data?.isEmpty ?? true)) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }

            List<NotificationData> notifications = snapshot.data ?? [];

            if (notifications.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.all(AppSizes.medium),
              itemCount: notifications.length + 1,
              separatorBuilder: (context, index) => Gaps.vGap12,
              itemBuilder: (context, index) {
                if (index == notifications.length) {
                  return _buildLoadMoreIndicator();
                }

                return NotificationItem(
                  notification: notifications[index],
                  onTap: () => bloc.markAsRead(notifications[index].id ?? ''),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.medium),
      itemCount: 5,
      separatorBuilder: (context, index) => Gaps.vGap12,
      itemBuilder: (context, index) => NotificationItemShimmer(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: FigmaColors.textSecondary,
          ),
          Gaps.vGap16,
          Text(
            'No notifications',
            style: AppTextStyles.h3.copyWith(
              color: FigmaColors.textSecondary,
            ),
          ),
          Gaps.vGap8,
          Text(
            'You are all caught up!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: FigmaColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: FigmaColors.error,
          ),
          Gaps.vGap16,
          Text(
            'Error loading notifications',
            style: AppTextStyles.h3,
          ),
          Gaps.vGap8,
          Text(
            error,
            style: AppTextStyles.bodySmall.copyWith(
              color: FigmaColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          Gaps.vGap16,
          ResponsiveButton(
            text: 'Retry',
            type: FigmaButtonType.primary,
            onPressed: () => bloc.getNotifications(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return StreamBuilder<bool>(
      stream: bloc.streamIsLoadingMore,
      builder: (context, snapshot) {
        bool isLoadingMore = snapshot.data ?? false;

        if (!isLoadingMore) {
          return SizedBox.shrink();
        }

        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.medium),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bloc.dispose();
    super.dispose();
  }
}
```

---

### 2. Notification Item Widget

```dart
class NotificationItem extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onTap;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRead = notification.isRead ?? false;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        padding: EdgeInsets.all(AppSizes.medium),
        decoration: BoxDecoration(
          color: isRead
              ? AppColors.getBackgroundCard(context)
              : FigmaColors.primaryBlue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: isRead
                ? Colors.transparent
                : FigmaColors.primaryBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread indicator
            if (!isRead)
              Container(
                margin: EdgeInsets.only(right: 12, top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: FigmaColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Notification',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(notification.createAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  Gaps.vGap8,

                  // Content
                  Text(
                    notification.content ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: FigmaColors.textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }
}
```

---

### 3. Notification Item Shimmer (Loading State)

```dart
class NotificationItemShimmer extends StatelessWidget {
  const NotificationItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(AppSizes.medium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.white,
                ),
                Container(
                  width: 60,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
            Gaps.vGap8,
            Container(
              width: double.infinity,
              height: 14,
              color: Colors.white,
            ),
            Gaps.vGap4,
            Container(
              width: 200,
              height: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 4. Notification BLoC Implementation

#### Notification BLoC (presentation/base/notifications/bloc/notification_bloc.dart):
```dart
class NotificationBloc {
  late BuildContext context;

  final streamNotifications = BehaviorSubject<List<NotificationData>>();
  final streamIsLoading = BehaviorSubject<bool>();
  final streamIsLoadingMore = BehaviorSubject<bool>();
  final streamError = BehaviorSubject<String?>();
  final streamUnreadCount = BehaviorSubject<int>();

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreData = true;
  List<NotificationData> _allNotifications = [];

  NotificationBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
    streamIsLoadingMore.add(false);
    streamUnreadCount.add(0);
  }

  Future<void> getNotifications() async {
    _currentPage = 1;
    _hasMoreData = true;
    streamIsLoading.add(true);

    try {
      NotificationReqModel model = NotificationReqModel(
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );

      ResponseModel responseModel = await Repository.getNotifications(
        context,
        model,
      );

      if (responseModel.success ?? false) {
        NotificationResModel notificationRes =
            NotificationResModel.fromJson(responseModel.result ?? {});

        _allNotifications = notificationRes.data ?? [];
        streamNotifications.add(_allNotifications);

        // Update unread count
        _updateUnreadCount();

        // Check if there's more data
        if (_allNotifications.length < _pageSize) {
          _hasMoreData = false;
        }
      } else {
        streamError.add(responseModel.message ?? 'Failed to load notifications');
      }
    } catch (e) {
      streamError.add('An error occurred: $e');
    }

    streamIsLoading.add(false);
  }

  Future<void> loadMoreNotifications() async {
    if (!_hasMoreData || (streamIsLoadingMore.value ?? false)) {
      return;
    }

    _currentPage++;
    streamIsLoadingMore.add(true);

    try {
      NotificationReqModel model = NotificationReqModel(
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );

      ResponseModel responseModel = await Repository.getNotifications(
        context,
        model,
      );

      if (responseModel.success ?? false) {
        NotificationResModel notificationRes =
            NotificationResModel.fromJson(responseModel.result ?? {});

        List<NotificationData> newNotifications = notificationRes.data ?? [];

        if (newNotifications.isEmpty || newNotifications.length < _pageSize) {
          _hasMoreData = false;
        }

        _allNotifications.addAll(newNotifications);
        streamNotifications.add(_allNotifications);

        // Update unread count
        _updateUnreadCount();
      }
    } catch (e) {
      print('Error loading more notifications: $e');
    }

    streamIsLoadingMore.add(false);
  }

  Future<void> refreshNotifications() async {
    await getNotifications();
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      // Update UI immediately (optimistic update)
      int index = _allNotifications.indexWhere((n) => n.id == notificationId);
      if (index != -1 && !(_allNotifications[index].isRead ?? false)) {
        _allNotifications[index].isRead = true;
        streamNotifications.add(_allNotifications);
        _updateUnreadCount();
      }

      // Call API to mark as read
      ResponseModel response = await Repository.markNotificationAsRead(
        context,
        notificationId,
      );

      if (!(response.success ?? false)) {
        // Revert if API fails
        if (index != -1) {
          _allNotifications[index].isRead = false;
          streamNotifications.add(_allNotifications);
          _updateUnreadCount();
        }
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      // Update UI immediately
      for (var notification in _allNotifications) {
        notification.isRead = true;
      }
      streamNotifications.add(_allNotifications);
      _updateUnreadCount();

      // Call API
      ResponseModel response = await Repository.markAllNotificationsAsRead(
        context,
      );

      if (!(response.success ?? false)) {
        // Revert if API fails
        await getNotifications();
      }
    } catch (e) {
      print('Error marking all as read: $e');
      await getNotifications();
    }
  }

  void _updateUnreadCount() {
    int unreadCount = _allNotifications.where((n) => !(n.isRead ?? false)).length;
    streamUnreadCount.add(unreadCount);

    // Update global notification count
    Globals.mainBloc?.streamNotificationCount.add(unreadCount);
  }

  void dispose() {
    streamNotifications.close();
    streamIsLoading.close();
    streamIsLoadingMore.close();
    streamError.close();
    streamUnreadCount.close();
  }
}
```

---

### 5. Notification Data Model

#### Notification Response Model (data/model/res/notification_res_model.dart):
```dart
class NotificationResModel {
  List<NotificationData>? data;
  int? totalCount;
  int? pageNumber;
  int? pageSize;

  NotificationResModel({
    this.data,
    this.totalCount,
    this.pageNumber,
    this.pageSize,
  });

  factory NotificationResModel.fromJson(Map<String, dynamic> json) {
    return NotificationResModel(
      data: (json['data'] as List?)
          ?.map((item) => NotificationData.fromJson(item))
          .toList(),
      totalCount: json['totalCount'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
    );
  }
}

class NotificationData {
  String? id;
  String? content;
  DateTime? createAt;
  bool? isRead;
  String? type;
  Map<String, dynamic>? metadata;

  NotificationData({
    this.id,
    this.content,
    this.createAt,
    this.isRead,
    this.type,
    this.metadata,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      content: json['content'],
      createAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'])
          : null,
      isRead: json['isRead'] ?? false,
      type: json['type'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createAt': createAt?.toIso8601String(),
      'isRead': isRead,
      'type': type,
      'metadata': metadata,
    };
  }
}
```

---

### 6. Notification Badge Integration

#### Update Bottom Navigation with Badge:
```dart
BottomNavigationBarItem(
  icon: StreamBuilder<int>(
    stream: Globals.mainBloc?.streamNotificationCount,
    builder: (context, snapshot) {
      int count = snapshot.data ?? 0;
      return Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: FigmaColors.error,
        textColor: Colors.white,
        child: Icon(Icons.notifications_outlined),
      );
    },
  ),
  activeIcon: Icon(Icons.notifications),
  label: 'Notifications',
),
```

---

## Notification Flow Diagram

```
User Opens Notification Tab
         ↓
NotificationBloc.getNotifications()
         ↓
API Call (Page 1, Size 20)
         ↓
Parse NotificationResModel
         ↓
Update streamNotifications
         ↓
Display in ListView
         │
         ├─→ User Scrolls to Bottom
         │        ↓
         │   loadMoreNotifications()
         │        ↓
         │   API Call (Page 2, Size 20)
         │        ↓
         │   Append to List
         │        ↓
         │   Update Stream
         │
         ├─→ User Taps Notification
         │        ↓
         │   markAsRead(notificationId)
         │        ↓
         │   Optimistic UI Update
         │        ↓
         │   API Call to Mark Read
         │        ↓
         │   Update Unread Count
         │
         └─→ User Pulls to Refresh
                  ↓
             refreshNotifications()
                  ↓
             Reset Page to 1
                  ↓
             Load Fresh Data
```

---

## Key Deliverables

✅ **Notification List**: Displays all notifications
✅ **Pagination**: Load more on scroll
✅ **Pull to Refresh**: Refresh notification list
✅ **Read/Unread Status**: Visual indicators
✅ **Badge Counter**: Shows unread count
✅ **Time Formatting**: Relative time display
✅ **Empty State**: User-friendly empty screen
✅ **Loading States**: Shimmer effect
✅ **Mark as Read**: Individual and bulk
✅ **Error Handling**: Proper error display

---

## UI Components

### States:
1. **Loading State**: Shimmer placeholders
2. **Empty State**: No notifications message
3. **Error State**: Error with retry button
4. **Content State**: List of notifications
5. **Load More State**: Bottom loading indicator

### Visual Indicators:
1. **Unread Dot**: Blue dot for unread
2. **Background Color**: Light blue for unread
3. **Border**: Subtle border for unread
4. **Badge**: Red badge with count
5. **Time**: Relative time format

---

## Success Criteria

✅ Notifications load successfully
✅ Pagination works smoothly
✅ Pull-to-refresh updates list
✅ Read/unread status updates correctly
✅ Badge count updates in real-time
✅ Time formatting displays correctly
✅ Empty state shows properly
✅ Loading states display correctly
✅ Mark all as read works
✅ Error handling is robust

---

**Step Status**: ✅ Completed
**Next Step**: [Step 7: Google Maps Integration & Restaurant Search](STEP_7_GOOGLE_MAPS.md)
