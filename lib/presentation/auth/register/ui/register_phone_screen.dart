import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/auth/register/bloc/register_controller.dart';

class RegisterPhoneScreen extends StatelessWidget {
  final RegisterController controller;

  const RegisterPhoneScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: Column(
        children: [
          // Spacer đẩy title xuống giữa màn hình
          const Spacer(),
          // Tiêu đề "Đăng ký" theo Figma
          Text(
            'Đăng ký',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: AppColors.getTextColor(context),
            ),
          ),
          const SizedBox(height: 48),
          // Phone number field
          StreamBuilder<String?>(
            stream: controller.phoneErrorStream,
            initialData: null,
            builder: (_, snapshot) {
              return CustomTextField(
                maxLines: 1,
                controller: controller.phoneController,
                focusNode: controller.phoneFocusNode,
                hintText: 'Nhập số điện thoại',
                errorMessage: snapshot.data,
                textInputType: TextInputType.phone,
                backgroundColor: snapshot.data == null
                    ? Colors.white
                    : AppColors.red.withValues(alpha: 0.1),
                borDerColor: snapshot.data == null
                    ? AppColors.grey
                    : AppColors.red,
                textInputColor: const Color(0xFF616161),
                fontSizeHint: 16,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              );
            },
          ),
          const Spacer(),
          // Submit button
          StreamBuilder<RegisterState>(
            stream: controller.stateStream,
            builder: (context, stateSnapshot) {
              final isLoading = stateSnapshot.data?.isLoading ?? false;
      
              return StreamBuilder<bool>(
                stream: controller.enableSubmitStream,
                initialData: false,
                builder: (_, enableSnapshot) {
                  bool enable = enableSnapshot.data ?? false;
                  return Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: enable && !isLoading
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF5691FF),
                                Color(0xFFDE50D0),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: enable && !isLoading ? null : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: enable && !isLoading
                            ? controller.submitPhoneNumber
                            : null,
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Tiếp tục',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    color: enable ? Colors.white : Colors.black54,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
