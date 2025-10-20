# Step 5: Home Screen & Main Navigation

## Overview
This step implements the main application interface including the home screen, bottom navigation, user profile display, and quick access menu. The home screen serves as the central hub for users to access all major features of the application.

## Duration
**4-5 days**

## Status
**🔄 In Progress**

## Dependencies
- Step 1: Project Setup (completed)
- Step 2: Architecture & Design System (completed)
- Step 4: Authentication System (completed)

## Objectives
- Build home screen with user profile card
- Implement bottom navigation system
- Create quick action menu
- Display news feed/activity stream
- Implement screen navigation logic
- Add badge notifications
- Create responsive layout
- Integrate user data display

---

## Tasks Completed

### 1. Main Navigation Structure

#### Main Screen with Bottom Navigation:
```dart
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainBloc(context);
    bloc.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: bloc.streamCurrentIndex,
      builder: (context, snapshot) {
        int currentIndex = snapshot.data ?? 0;

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [
              HomeScreen(),
              MapScreen(),
              NotificationScreen(),
              AccountScreen(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => bloc.streamCurrentIndex.add(index),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
```

#### Custom Bottom Navigation Bar:
```dart
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getBackgroundCard(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: FigmaColors.primaryBlue,
        unselectedItemColor: FigmaColors.textSecondary,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: StreamBuilder<int>(
              stream: Globals.mainBloc?.streamNotificationCount,
              builder: (context, snapshot) {
                int count = snapshot.data ?? 0;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: Icon(Icons.notifications_outlined),
                );
              },
            ),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
```

---

### 2. Home Screen Implementation

#### Home Screen UI:
```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Globals.mainBloc?.getUserInfo();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // User Profile Card
              UserProfileCard(),
              Gaps.vGap16,

              // Quick Actions
              QuickActionMenu(),
              Gaps.vGap16,

              // News Feed / Activity Stream
              NewsFeedSection(),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Home App Bar:
```dart
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: FigmaColors.primaryBlue,
      elevation: 0,
      title: Row(
        children: [
          // App Logo
          Image.asset(
            'assets/icons/logo.png',
            height: 32,
            width: 32,
          ),
          Gaps.hGap8,
          Text(
            'Go Mep',
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        // Notification bell with badge
        StreamBuilder<int>(
          stream: Globals.mainBloc?.streamNotificationCount,
          builder: (context, snapshot) {
            int count = snapshot.data ?? 0;
            return IconButton(
              icon: Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              onPressed: () {
                Globals.mainBloc?.streamCurrentIndex.add(2);
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
```

---

### 3. User Profile Card

```dart
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserMeResModel?>(
      stream: Globals.mainBloc?.streamUserInfo,
      builder: (context, snapshot) {
        UserMeResModel? user = snapshot.data;

        if (user == null) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 120,
              margin: EdgeInsets.all(AppSizes.medium),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              ),
            ),
          );
        }

        return Container(
          margin: EdgeInsets.all(AppSizes.medium),
          padding: EdgeInsets.all(AppSizes.medium),
          decoration: BoxDecoration(
            color: AppColors.getBackgroundCard(context),
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 32,
                backgroundColor: FigmaColors.primaryBlue,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Icon(Icons.person, size: 32, color: Colors.white)
                    : null,
              ),
              Gaps.hGap16,

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName ?? 'N/A',
                      style: AppTextStyles.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.vGap4,
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: FigmaColors.textSecondary,
                        ),
                        Gaps.hGap4,
                        Text(
                          user.phoneNumber ?? 'N/A',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: FigmaColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Gaps.vGap4,
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 16,
                          color: FigmaColors.textSecondary,
                        ),
                        Gaps.hGap4,
                        Expanded(
                          child: Text(
                            user.email ?? 'N/A',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: FigmaColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

---

### 4. Quick Action Menu

```dart
class QuickActionMenu extends StatelessWidget {
  const QuickActionMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.medium),
      padding: EdgeInsets.all(AppSizes.medium),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundCard(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.h3,
          ),
          Gaps.vGap16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              QuickActionButton(
                icon: Icons.map,
                label: 'Map',
                color: FigmaColors.primaryBlue,
                onTap: () {
                  Globals.mainBloc?.streamCurrentIndex.add(1);
                },
              ),
              QuickActionButton(
                icon: Icons.person,
                label: 'Profile',
                color: Colors.green,
                onTap: () {
                  Globals.mainBloc?.streamCurrentIndex.add(3);
                },
              ),
              QuickActionButton(
                icon: Icons.restaurant,
                label: 'Restaurants',
                color: Colors.orange,
                onTap: () {
                  Globals.mainBloc?.streamCurrentIndex.add(1);
                },
              ),
              QuickActionButton(
                icon: Icons.settings,
                label: 'Settings',
                color: Colors.grey,
                onTap: () {
                  CustomNavigator.push(context, SettingsScreen());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

#### Quick Action Button:
```dart
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.medium),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Icon(
              icon,
              size: AppSizes.iconLarge,
              color: color,
            ),
          ),
          Gaps.vGap8,
          Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
```

---

### 5. News Feed Section

```dart
class NewsFeedSection extends StatelessWidget {
  const NewsFeedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.medium),
      padding: EdgeInsets.all(AppSizes.medium),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundCard(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Updates',
            style: AppTextStyles.h3,
          ),
          Gaps.vGap16,

          // News feed items
          NewsFeedItem(
            title: 'Welcome to Go Mep',
            description: 'Thank you for joining our platform',
            time: '2 hours ago',
            icon: Icons.celebration,
          ),
          Gaps.vGap12,
          NewsFeedItem(
            title: 'New restaurants added',
            description: '5 new restaurants near you',
            time: '1 day ago',
            icon: Icons.restaurant_menu,
          ),
          Gaps.vGap12,
          NewsFeedItem(
            title: 'App update available',
            description: 'Version 1.1.0 with new features',
            time: '2 days ago',
            icon: Icons.system_update,
          ),
        ],
      ),
    );
  }
}
```

#### News Feed Item:
```dart
class NewsFeedItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;

  const NewsFeedItem({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: FigmaColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: FigmaColors.primaryBlue,
            size: 20,
          ),
        ),
        Gaps.hGap12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.vGap4,
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: FigmaColors.textSecondary,
                ),
              ),
              Gaps.vGap4,
              Text(
                time,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

---

### 6. Main BLoC Implementation

```dart
class MainBloc {
  late BuildContext context;

  final streamUserInfo = BehaviorSubject<UserMeResModel?>();
  final streamIsLoading = BehaviorSubject<bool>();
  final streamCurrentIndex = BehaviorSubject<int>();
  final streamNotificationCount = BehaviorSubject<int>();

  MainBloc(BuildContext context) {
    this.context = context;
    Globals.mainBloc = this;
    streamIsLoading.add(false);
    streamCurrentIndex.add(0);
    streamNotificationCount.add(0);
  }

  Future<void> getUserInfo() async {
    streamIsLoading.add(true);

    try {
      ResponseModel responseModel = await Repository.getUserMe(context);

      if (responseModel.success ?? false) {
        UserMeResModel userMeResModel =
            UserMeResModel.fromJson(responseModel.result ?? {});
        streamUserInfo.add(userMeResModel);
        Globals.userMeResModel = userMeResModel;
      }
    } catch (e) {
      print('Error getting user info: $e');
    }

    streamIsLoading.add(false);
  }

  Future<void> getNotificationCount() async {
    try {
      // Get unread notification count
      ResponseModel response = await Repository.getNotificationCount(context);

      if (response.success ?? false) {
        int count = response.result['count'] ?? 0;
        streamNotificationCount.add(count);
      }
    } catch (e) {
      print('Error getting notification count: $e');
    }
  }

  void navigateToTab(int index) {
    streamCurrentIndex.add(index);
  }

  void dispose() {
    streamUserInfo.close();
    streamIsLoading.close();
    streamCurrentIndex.close();
    streamNotificationCount.close();
  }
}
```

---

## Tasks To Complete

### 1. News Feed Integration
- [ ] Connect to real API for news feed
- [ ] Implement pagination for feed items
- [ ] Add pull-to-refresh functionality
- [ ] Add loading states

### 2. Enhanced User Profile
- [ ] Add profile image upload
- [ ] Implement edit profile functionality
- [ ] Add profile completion indicator

### 3. Notification Badge
- [ ] Real-time notification count updates
- [ ] Badge animation on new notifications
- [ ] Clear badge on notification view

### 4. Quick Actions
- [ ] Add more quick action items
- [ ] Make quick actions configurable
- [ ] Add analytics tracking

---

## Navigation Flow

```
Main Screen
     │
     ├─→ Tab 0: Home Screen
     │       ├─→ User Profile Card
     │       ├─→ Quick Actions Menu
     │       └─→ News Feed
     │
     ├─→ Tab 1: Map Screen
     │       └─→ Google Maps with restaurants
     │
     ├─→ Tab 2: Notification Screen
     │       └─→ Notification list
     │
     └─→ Tab 3: Account Screen
             └─→ Profile and settings
```

---

## Key Deliverables

✅ **Main Screen Structure**: Bottom navigation with 4 tabs
✅ **Home Screen**: User profile, quick actions, news feed
✅ **Bottom Navigation**: Custom styled with badges
✅ **User Profile Card**: Display user information
✅ **Quick Action Menu**: Easy access to key features
✅ **News Feed**: Latest updates and announcements
🔄 **Notification Badge**: Real-time count display
🔄 **Profile Integration**: User data from API
🔄 **Responsive Layout**: Adapts to screen sizes

---

## Success Criteria

✅ Bottom navigation works smoothly
✅ Home screen displays user information
✅ Quick actions navigate correctly
✅ News feed displays properly
✅ Pull-to-refresh works
✅ Loading states show correctly
🔄 Notification badges update in real-time
🔄 Profile data loads from API
🔄 All screens accessible from navigation

---

**Step Status**: 🔄 In Progress
**Next Step**: [Step 6: Notification System Implementation](STEP_6_NOTIFICATIONS.md)
