import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/presentation/auth/register/bloc/register_controller.dart';

class RegisterPasswordScreen extends StatelessWidget {
  final RegisterController controller;

  const RegisterPasswordScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Spacer đẩy title xuống giữa màn hình
        const Spacer(),
        // Tiêu đề "Mật khẩu"
        Text(
          'Mật khẩu',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: AppColors.getTextColor(context),
          ),
        ),
        const SizedBox(height: 48),
        // Password field
        StreamBuilder2<String?, bool>(
          stream1: controller.passwordErrorStream,
          initialData1: null,
          stream2: controller.showPasswordStream,
          initialData2: false,
          builder: (_, errorSnapshot, showSnapshot) {
            return Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: errorSnapshot != null
                    ? Border.all(color: AppColors.red, width: 1)
                    : null,
              ),
              child: TextField(
                controller: controller.passwordController,
                focusNode: controller.passwordFocusNode,
                obscureText: showSnapshot == false,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF616161),
                  fontFamily: 'Roboto Condensed',
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập mật khẩu',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF616161),
                    fontFamily: 'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      showSnapshot
                          ? 'assets/figma/ic_eye_filled.svg'
                          : 'assets/figma/ic_eye_outline.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: controller.toggleShowPassword,
                  ),
                ),
              ),
            );
          },
        ),
        StreamBuilder<String?>(
          stream: controller.passwordErrorStream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 16),
        // Confirm Password field
        StreamBuilder2<String?, bool>(
          stream1: controller.confirmPasswordErrorStream,
          initialData1: null,
          stream2: controller.showConfirmPasswordStream,
          initialData2: false,
          builder: (_, errorSnapshot, showSnapshot) {
            return Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: errorSnapshot != null
                    ? Border.all(color: AppColors.red, width: 1)
                    : null,
              ),
              child: TextField(
                controller: controller.confirmPasswordController,
                focusNode: controller.confirmPasswordFocusNode,
                obscureText: showSnapshot == false,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF616161),
                  fontFamily: 'Roboto Condensed',
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập lại mật khẩu',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF616161),
                    fontFamily: 'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      showSnapshot
                          ? 'assets/figma/ic_eye_filled.svg'
                          : 'assets/figma/ic_eye_outline.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: controller.toggleShowConfirmPassword,
                  ),
                ),
              ),
            );
          },
        ),
        StreamBuilder<String?>(
          stream: controller.confirmPasswordErrorStream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 16),
        // Password requirements theo Figma
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'Mật khẩu bao gồm:\n'),
                TextSpan(text: '• 6-12 ký tự Chữ hoặc số.\n'),
                TextSpan(text: '• Không bao gồm ký tự đặt biệt: @, #,\$,%,..'),
              ],
            ),
          ),
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
                          ? controller.submitPassword
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
                                'Đăng ký',
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
    );
  }
}

// StreamBuilder2 for listening to 2 streams
class StreamBuilder2<A, B> extends StatelessWidget {
  final Stream<A> stream1;
  final A initialData1;
  final Stream<B> stream2;
  final B initialData2;
  final Widget Function(BuildContext, A, B) builder;

  const StreamBuilder2({
    Key? key,
    required this.stream1,
    required this.initialData1,
    required this.stream2,
    required this.initialData2,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<A>(
      stream: stream1,
      initialData: initialData1,
      builder: (context, snapshot1) {
        return StreamBuilder<B>(
          stream: stream2,
          initialData: initialData2,
          builder: (context, snapshot2) {
            return builder(context, snapshot1.data as A, snapshot2.data as B);
          },
        );
      },
    );
  }
}
