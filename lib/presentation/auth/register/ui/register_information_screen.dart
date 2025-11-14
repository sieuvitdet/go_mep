import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/auth/register/bloc/register_controller.dart';

class RegisterInformationScreen extends StatelessWidget {
  final RegisterController controller;

  const RegisterInformationScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          'Thông tin cá nhân',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(context),
          ),
        ),
        const SizedBox(height: 12),
        // Subtitle
        Text(
          'Hoàn thiện thông tin để tiếp tục',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 48),
        // Full Name field
        CustomTextField(
          maxLines: 1,
          controller: controller.fullNameController,
          hintText: 'Họ và tên *',
          backgroundColor: Colors.white,
          borDerColor: AppColors.grey,
          textInputColor: const Color(0xFF616161),
          fontSizeHint: 16,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        const SizedBox(height: 16),
        // Date of Birth field
        GestureDetector(
          onTap: () => controller.selectDateOfBirth(context),
          child: AbsorbPointer(
            child: CustomTextField(
              maxLines: 1,
              controller: controller.dateOfBirthController,
              hintText: 'Ngày sinh (DD-MM-YYYY)',
              backgroundColor: Colors.white,
              borDerColor: AppColors.grey,
              textInputColor: const Color(0xFF616161),
              fontSizeHint: 16,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Address field với button lấy location
        Stack(
          children: [
            CustomTextField(
              maxLines: 1,
              controller: controller.addressController,
              hintText: 'Địa chỉ',
              backgroundColor: Colors.white,
              borDerColor: AppColors.grey,
              textInputColor: const Color(0xFF616161),
              fontSizeHint: 16,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: StreamBuilder<bool>(
                stream: controller.fetchingLocationStream,
                initialData: false,
                builder: (context, snapshot) {
                  final isFetching = snapshot.data ?? false;
                  return GestureDetector(
                    onTap: isFetching ? null : controller.getCurrentLocation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      child: isFetching
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              Icons.my_location,
                              color: AppColors.primary,
                              size: 24,
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Submit button
        StreamBuilder<bool>(
          stream: controller.enableSubmitStream,
          initialData: false,
          builder: (context, snapshot) {
            final isEnabled = snapshot.data ?? false;
            return CustomButton(
              text: 'Hoàn thành',
              onTap: isEnabled ? controller.submitInformation : null,
              color: isEnabled ? AppColors.primary : AppColors.grey.withValues(alpha: 0.3),
              textColor: isEnabled ? Colors.white : AppColors.grey,
              radius: 8,
              enable: isEnabled,
            );
          },
        ),
        const SizedBox(height: 16),
        // Skip button
        TextButton(
          onPressed: controller.skipInformation,
          child: Text(
            'Bỏ qua',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
