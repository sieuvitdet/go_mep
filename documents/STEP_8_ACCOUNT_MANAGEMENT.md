# Step 8: Personal Account Management

## Overview
This step implements the personal account management screen where users can view their profile information, update settings, change password, switch languages, toggle dark mode, and logout. The implementation follows 100% Figma design specifications and uses the BLoC pattern for state management.

## Duration
**3-4 days**

## Status
**🔄 In Progress**

## Dependencies
- Step 1: Project Setup (completed)
- Step 2: Architecture & Design System (completed)
- Step 3: Network Layer & API Integration (completed)
- Step 4: Authentication System (completed)
- Step 5: Home Screen & Main Navigation (completed)

## Objectives
- Display user profile information
- Implement profile editing (future)
- Create settings management
- Add change password functionality
- Implement language selection
- Add dark mode toggle
- Create notification settings
- Build about app section
- Implement logout functionality

---

## Tasks Completed

### 1. Account Screen UI

#### Account Screen (presentation/base/personal/ui/account_screen.dart):
```dart
class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AccountBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = AccountBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Account',
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Globals.mainBloc?.streamCurrentIndex.add(0);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Globals.mainBloc?.getUserInfo();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(),
              Gaps.vGap16,

              // Personal Information Section
              _buildPersonalInfoSection(),
              Gaps.vGap16,

              // Settings Section
              _buildSettingsSection(),
              Gaps.vGap24,

              // Logout Button
              _buildLogoutButton(),
              Gaps.vGap24,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return StreamBuilder<UserMeResModel?>(
      stream: Globals.mainBloc?.streamUserInfo,
      builder: (context, snapshot) {
        UserMeResModel? user = snapshot.data;

        return Container(
          padding: EdgeInsets.all(AppSizes.large),
          color: AppColors.getBackgroundCard(context),
          child: Column(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: FigmaColors.primaryBlue,
                    backgroundImage: user?.avatarUrl != null
                        ? NetworkImage(user!.avatarUrl!)
                        : null,
                    child: user?.avatarUrl == null
                        ? Icon(Icons.person, size: 48, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: FigmaColors.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        onPressed: () => bloc.changeProfilePicture(),
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
              Gaps.vGap16,

              // Name
              Text(
                user?.fullName ?? 'N/A',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              Gaps.vGap4,

              // Username
              Text(
                '@${user?.username ?? 'N/A'}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: FigmaColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfoSection() {
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
      child: StreamBuilder<UserMeResModel?>(
        stream: Globals.mainBloc?.streamUserInfo,
        builder: (context, snapshot) {
          UserMeResModel? user = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: AppTextStyles.h3,
              ),
              Gaps.vGap16,

              // Full Name
              _buildInfoRow(
                label: 'Full Name',
                value: user?.fullName ?? 'N/A',
                icon: Icons.person,
              ),
              Gaps.vGap12,

              // Phone Number
              _buildInfoRow(
                label: 'Phone Number',
                value: user?.phoneNumber ?? 'N/A',
                icon: Icons.phone,
              ),
              Gaps.vGap12,

              // Email
              _buildInfoRow(
                label: 'Email',
                value: user?.email ?? 'N/A',
                icon: Icons.email,
              ),
              Gaps.vGap12,

              // Birthday
              _buildInfoRow(
                label: 'Birthday',
                value: user?.birthday ?? 'N/A',
                icon: Icons.cake,
              ),
              Gaps.vGap12,

              // Gender
              _buildInfoRow(
                label: 'Gender',
                value: user?.gender ?? 'N/A',
                icon: Icons.wc,
              ),
              Gaps.vGap12,

              // Address
              _buildInfoRow(
                label: 'Address',
                value: user?.address ?? 'N/A',
                icon: Icons.location_on,
                maxLines: 2,
              ),
              Gaps.vGap12,

              // Note
              if (user?.note != null && user!.note!.isNotEmpty)
                _buildInfoRow(
                  label: 'Note',
                  value: user.note!,
                  icon: Icons.note,
                  maxLines: 3,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    int maxLines = 1,
  }) {
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
            size: 20,
            color: FigmaColors.primaryBlue,
          ),
        ),
        Gaps.hGap12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: FigmaColors.textSecondary,
                ),
              ),
              Gaps.vGap4,
              Text(
                value,
                style: AppTextStyles.bodyMedium,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
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
            'Settings',
            style: AppTextStyles.h3,
          ),
          Gaps.vGap16,

          // Change Password
          SettingItem(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () => bloc.navigateToChangePassword(),
          ),
          Divider(),

          // Language
          SettingItem(
            icon: Icons.language,
            title: 'Language',
            trailing: StreamBuilder<String>(
              stream: bloc.streamCurrentLanguage,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? 'Vietnamese',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: FigmaColors.textSecondary,
                  ),
                );
              },
            ),
            onTap: () => bloc.showLanguageDialog(),
          ),
          Divider(),

          // Dark Mode
          SettingItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: StreamBuilder<bool>(
              stream: bloc.streamDarkMode,
              builder: (context, snapshot) {
                return Switch(
                  value: snapshot.data ?? false,
                  onChanged: (value) => bloc.toggleDarkMode(value),
                  activeColor: FigmaColors.primaryBlue,
                );
              },
            ),
            onTap: null,
          ),
          Divider(),

          // Notifications
          SettingItem(
            icon: Icons.notifications,
            title: 'Notification Settings',
            onTap: () => bloc.navigateToNotificationSettings(),
          ),
          Divider(),

          // About
          SettingItem(
            icon: Icons.info,
            title: 'About App',
            onTap: () => bloc.showAboutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.medium),
      child: StreamBuilder<bool>(
        stream: bloc.streamIsLoading,
        builder: (context, snapshot) {
          return ResponsiveButton(
            text: 'Logout',
            type: FigmaButtonType.outlined,
            onPressed: () => bloc.logout(),
            isLoading: snapshot.data ?? false,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
```

---

### 2. Setting Item Widget

```dart
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.small),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: FigmaColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: FigmaColors.primaryBlue,
              ),
            ),
            Gaps.hGap12,
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium,
              ),
            ),
            if (trailing != null) trailing!,
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: FigmaColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
```

---

### 3. Account BLoC Implementation

#### Account BLoC (presentation/base/personal/bloc/account_bloc.dart):
```dart
class AccountBloc {
  late BuildContext context;

  final streamIsLoading = BehaviorSubject<bool>();
  final streamCurrentLanguage = BehaviorSubject<String>();
  final streamDarkMode = BehaviorSubject<bool>();

  AccountBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
    _loadSettings();
  }

  void _loadSettings() {
    // Load current language
    String? languageCode = SharedPrefs.getLanguage();
    String languageName = _getLanguageName(languageCode ?? 'vi');
    streamCurrentLanguage.add(languageName);

    // Load dark mode setting
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false)
        .themeMode == ThemeMode.dark;
    streamDarkMode.add(isDarkMode);
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'vi':
        return 'Vietnamese';
      case 'en':
        return 'English';
      case 'zh':
        return 'Chinese';
      default:
        return 'Vietnamese';
    }
  }

  void navigateToChangePassword() {
    CustomNavigator.push(context, ChangePasswordScreen());
  }

  void showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Vietnamese', 'vi'),
            _buildLanguageOption('English', 'en'),
            _buildLanguageOption('Chinese', 'zh'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String name, String code) {
    return ListTile(
      title: Text(name),
      onTap: () async {
        await SharedPrefs.setLanguage(code);
        streamCurrentLanguage.add(name);
        Navigator.pop(context);

        // Restart app to apply language change
        Globals.myApp?.currentState?.setState(() {});
      },
    );
  }

  void toggleDarkMode(bool value) {
    Provider.of<ThemeProvider>(context, listen: false).setTheme(
      value ? ThemeMode.dark : ThemeMode.light,
    );
    streamDarkMode.add(value);
  }

  void navigateToNotificationSettings() {
    CustomNavigator.push(context, NotificationSettingsScreen());
  }

  void showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Go Mep'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            Gaps.vGap8,
            Text('Go Mep Application'),
            Gaps.vGap8,
            Text('© 2025 Go Mep. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> changeProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        streamIsLoading.add(true);

        // Compress image
        File compressedFile = await _compressImage(File(image.path));

        // Upload to server
        ResponseModel response = await Repository.uploadProfilePicture(
          context,
          compressedFile,
        );

        if (response.success ?? false) {
          Utility.showToast('Profile picture updated successfully');
          await Globals.mainBloc?.getUserInfo();
        } else {
          Utility.showToast('Failed to update profile picture');
        }

        streamIsLoading.add(false);
      }
    } catch (e) {
      print('Error changing profile picture: $e');
      Utility.showToast('An error occurred');
      streamIsLoading.add(false);
    }
  }

  Future<File> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.parent.path}/compressed_${file.path.split('/').last}',
      quality: 80,
    );
    return File(result!.path);
  }

  Future<void> logout() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(color: FigmaColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    streamIsLoading.add(true);

    try {
      // Call logout API
      await Repository.logout(context);

      // Clear local data
      await SharedPrefs.clearAuthData();
      Globals.userMeResModel = null;
      Globals.authToken = null;

      // Navigate to login
      CustomNavigator.pushReplacement(context, LoginScreen());
    } catch (e) {
      print('Logout error: $e');
      // Even if API fails, clear local data and navigate
      await SharedPrefs.clearAuthData();
      CustomNavigator.pushReplacement(context, LoginScreen());
    }

    streamIsLoading.add(false);
  }

  void dispose() {
    streamIsLoading.close();
    streamCurrentLanguage.close();
    streamDarkMode.close();
  }
}
```

---

## Tasks To Complete

### 1. Profile Editing
- [ ] Add edit profile button
- [ ] Create edit profile screen
- [ ] Implement field validation
- [ ] Add save changes functionality
- [ ] Show success/error messages

### 2. Profile Picture
- [x] Add camera icon overlay
- [ ] Implement image picker
- [ ] Add image cropping
- [ ] Upload to server
- [ ] Update display

### 3. Settings Enhancement
- [x] Language selection dialog
- [x] Dark mode toggle
- [ ] Notification preferences
- [ ] Privacy settings
- [ ] Terms and conditions

### 4. Logout Enhancement
- [x] Confirmation dialog
- [x] Clear local data
- [ ] Revoke tokens
- [ ] Clear cache

---

## Account Data Flow

```
User Opens Account Tab
     ↓
Load User Info from Globals
     ↓
Display Profile Header
     ↓
Show Personal Information
     ↓
Show Settings Options
     │
     ├─→ Change Password
     │        ↓
     │   Navigate to Change Password Screen
     │        ↓
     │   User Changes Password
     │        ↓
     │   API Call
     │        ↓
     │   Success Message
     │
     ├─→ Change Language
     │        ↓
     │   Show Language Dialog
     │        ↓
     │   User Selects Language
     │        ↓
     │   Save to SharedPrefs
     │        ↓
     │   Reload App
     │
     ├─→ Toggle Dark Mode
     │        ↓
     │   Update ThemeProvider
     │        ↓
     │   App Theme Changes
     │
     └─→ Logout
              ↓
         Show Confirmation Dialog
              ↓
         User Confirms
              ↓
         Call Logout API
              ↓
         Clear Local Data
              ↓
         Navigate to Login Screen
```

---

## Key Deliverables

✅ **Profile Display**: User information shown correctly
✅ **Profile Header**: Avatar, name, username
✅ **Personal Info Section**: All user details
✅ **Settings Section**: Change password, language, dark mode
✅ **Language Selection**: Multi-language support
✅ **Dark Mode Toggle**: Theme switching
✅ **Logout Functionality**: Clean logout with confirmation
🔄 **Profile Picture Upload**: Image selection and upload
🔄 **Edit Profile**: Full profile editing capability
🔄 **Notification Settings**: Preference management

---

## Success Criteria

✅ Account screen displays user information
✅ Settings options are functional
✅ Language selection works
✅ Dark mode toggle updates theme
✅ Logout clears data and navigates to login
✅ Profile header shows avatar correctly
✅ All info fields display properly
🔄 Profile picture upload works
🔄 Profile editing saves changes
🔄 100% Figma design compliance

---

**Step Status**: 🔄 In Progress
**Next Step**: [Step 9: Custom Popup Dialogs & UI Polish](STEP_9_UI_POLISH.md)
