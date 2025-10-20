import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
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
              final hasError = snapshot.data != null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: hasError ? AppColors.red : AppColors.grey, width: 1),
                    ),
                    child: TextField(
                      controller: controller.phoneController,
                      focusNode: controller.phoneFocusNode,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF616161),
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Nhập số điện thoại',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF616161),
                          fontFamily: 'Roboto Condensed',
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        snapshot.data!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.red,
                          fontFamily: 'Roboto Condensed',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
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
