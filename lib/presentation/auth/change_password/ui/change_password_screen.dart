import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/auth/change_password/bloc/change_password_bloc.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isChangePasswordFirstTime;
  ChangePasswordScreen({super.key, this.isChangePasswordFirstTime = false});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late ChangePasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChangePasswordBloc(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.getTextColor(context), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CustomText(
          text: 'Đổi mật khẩu',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.getTextColor(context),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              _bloc.onSubmit();
            },
            child: CustomText(
              text: 'Lưu',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.getTextColor(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Gaps.vGap16,
            StreamBuilder<bool>(
              stream: _bloc.streamShowPasswordOld,
              initialData: false,
              builder: (context, showPasswordSnapshot) {
                return StreamBuilder<String?>(
                  stream: _bloc.streamErrorPasswordOld,
                  builder: (context, errorSnapshot) {
                    return _buildPasswordField(
                      controller: _bloc.passwordOldController,
                      focusNode: _bloc.passwordOldNode,
                      hintText: 'Nhập mật khẩu cũ',
                      errorMessage: errorSnapshot.data,
                      isPasswordVisible: showPasswordSnapshot.data ?? false,
                      onShowPassword: () => _bloc.onShowPasswordOld(),
                      onChanged: (value) => _bloc.validateEnableButton(),
                    );
                  },
                );
              },
            ),
            Gaps.vGap16,
            StreamBuilder<bool>(
              stream: _bloc.streamShowPasswordNew,
              initialData: false,
              builder: (context, showPasswordSnapshot) {
                return StreamBuilder<String?>(
                  stream: _bloc.streamErrorPasswordNew,
                  builder: (context, errorSnapshot) {
                    return _buildPasswordField(
                      controller: _bloc.passwordNewController,
                      focusNode: _bloc.passwordNewNode,
                      hintText: 'Nhập mật khẩu mới',
                      errorMessage: errorSnapshot.data,
                      isPasswordVisible: showPasswordSnapshot.data ?? false,
                      onShowPassword: () => _bloc.onShowPasswordNew(),
                      onChanged: (value) => _bloc.validateEnableButton(),
                      maxLength: 15,
                    );
                  },
                );
              },
            ),
            Gaps.vGap16,
            StreamBuilder<bool>(
              stream: _bloc.streamShowPasswordConfirmNew,
              initialData: false,
              builder: (context, showPasswordSnapshot) {
                return StreamBuilder<String?>(
                  stream: _bloc.streamErrorConfirmPasswordNew,
                  builder: (context, errorSnapshot) {
                    return _buildPasswordField(
                      controller: _bloc.confirmPasswordNewController,
                      focusNode: _bloc.confirmPasswordNewNode,
                      hintText: 'Xác nhận mật khẩu mới',
                      errorMessage: errorSnapshot.data,
                      isPasswordVisible: showPasswordSnapshot.data ?? false,
                      onShowPassword: () => _bloc.onShowPasswordConfirmNew(),
                      onChanged: (value) => _bloc.validateEnableButton(),
                      maxLength: 15,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required String? errorMessage,
    required bool isPasswordVisible,
    required VoidCallback onShowPassword,
    required Function(String) onChanged,
    int? maxLength,
  }) {
    return CustomTextField(
      maxLines: 1,
      maxLength: maxLength,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      errorMessage: errorMessage,
      onChanged: onChanged,
      backgroundColor: errorMessage == null
          ? AppColors.getBackgroundCard(context)
          : AppColors.red.withValues(alpha: 0.1),
      borDerColor: errorMessage == null
          ? AppColors.getTextColor(context).withOpacity(0.3)
          : AppColors.red,
      suffixIcon: isPasswordVisible == false ? Assets.icEyeOff : Assets.icEye,
      suffixIconColor: AppColors.hint,
      onSuffixIconTap: onShowPassword,
      obscureText: isPasswordVisible == false,
      suffixIconSize: 24,
      textInputColor: AppColors.getTextColor(context),
      prefixIconWidget: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Icon(
          Icons.lock_outline,
          color: AppColors.getTextColor(context),
          size: 24,
        ),
      ),
      prefixIconConstraints: BoxConstraints(
        minWidth: 56,
        minHeight: 24,
      ),
      counterText: '',
    );
  }
}
