import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/widgets/custom_theme_switch.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/presentation/auth/change_password/ui/change_password_screen.dart';
import 'package:go_mep_application/presentation/base/personal/bloc/account_bloc.dart';
import 'package:go_mep_application/presentation/base/personal/ui/account_detail_screen.dart';
import 'package:go_mep_application/presentation/main/bloc/main_bloc.dart';

class AccountScreen extends StatefulWidget {
  final MainBloc mainBloc;
  const AccountScreen({super.key, required this.mainBloc});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AccountController _accountController;

  @override
  void initState() {
    super.initState();
    _accountController = AccountController();
    widget.mainBloc.getUserInfo();
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  void _navigateToEditProfile(UserMeResModel user) {
    CustomNavigator.push(context, AccountDetailScreen(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tài khoản',
                    style: TextStyle(
                      color: AppColors.getTextColor(context), 
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomThemeSwitch(),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: AppColors.getTextColor(context)),
                        color: AppColors.getBackgroundCard(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onSelected: (value) async {
                          if (value == 'change_password') {
                            CustomNavigator.push(context, ChangePasswordScreen());
                          } else if (value == 'logout') {
                            _showLogoutDialog();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'change_password',
                            child: Row(
                              children: [
                                Icon(Icons.lock_outline, color: AppColors.getTextColor(context), size: 20),
                                SizedBox(width: 12),
                                Text(
                                  'Đổi mật khẩu',
                                  style: TextStyle(
                                    color: AppColors.getTextColor(context),
                                    fontSize: 14,
                                    fontFamily: 'Roboto Condensed',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: AppColors.red, size: 20),
                                SizedBox(width: 12),
                                Text(
                                  'Đăng xuất',
                                  style: TextStyle(
                                    color: AppColors.red,
                                    fontSize: 14,
                                    fontFamily: 'Roboto Condensed',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // User Info Card
            Expanded(
              child: StreamBuilder<UserMeResModel?>(
                stream: widget.mainBloc.streamUserInfo.output,
                initialData: null,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.blue,
                      ),
                    );
                  }

                  final user = snapshot.data!;
                  _accountController.setUserInfo(user);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // User Profile Card
                        InkWell(
                          onTap: () => _navigateToEditProfile(user),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.getBackgroundCard(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.getBackgroundCard(context)),
                            ),
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: user.avatar != null && user.avatar!.isNotEmpty
                                        ? Image.network(
                                            user.avatar!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.person,
                                                color: AppColors.getTextColor(context),
                                                size: 32,
                                              );
                                            },
                                          )
                                        : Icon(
                                            Icons.person,
                                            color: AppColors.getTextColor(context),
                                            size: 32,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // User Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.fullName ?? 'Nguyễn Văn A',
                                        style: TextStyle(
                                          color: AppColors.getTextColor(context),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto Condensed',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Chỉnh sửa thông tin tài khoản',
                                        style: TextStyle(
                                          color: AppColors.getTextColor(context),
                                          fontSize: 14,
                                          fontFamily: 'Roboto Condensed',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.getTextColor(context),
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Đăng xuất',
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto Condensed',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Bạn có chắc chắn muốn đăng xuất?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                  fontSize: 16,
                  fontFamily: 'Roboto Condensed',
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto Condensed',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        _accountController.onLogOut(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.getTextColor(context),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto Condensed',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
