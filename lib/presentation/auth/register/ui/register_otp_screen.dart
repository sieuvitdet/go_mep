import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/presentation/auth/register/bloc/register_controller.dart';
import 'package:go_mep_application/presentation/auth/register/widget/custom_textfield_otp.dart';

class RegisterOTPScreen extends StatefulWidget {
  final RegisterController controller;

  const RegisterOTPScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<RegisterOTPScreen> createState() => _RegisterOTPScreenState();
}

class _RegisterOTPScreenState extends State<RegisterOTPScreen> {
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOTP() {
    if (_remainingSeconds == 0) {
      widget.controller.resendOTP();
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Spacer đẩy title xuống giữa màn hình
        const Spacer(),
        // Tiêu đề "OTP"
        Text(
          'OTP',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: AppColors.getTextColor(context),
          ),
        ),
        const SizedBox(height: 48),
        // OTP Input fields (4 asterisks)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: StreamBuilder<RegisterState>(
            stream: widget.controller.stateStream,
            builder: (context, snapshot) {
              final isLoading = snapshot.data?.isLoading ?? false;
              return CustomTextFieldOTP(
                onCompleted: (otp) {
                  if (!isLoading) {
                    widget.controller.verifyOTP(otp);
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Thông tin OTP
        StreamBuilder<RegisterState>(
          stream: widget.controller.stateStream,
          builder: (context, snapshot) {
            final phoneNumber = snapshot.data?.phoneNumber ?? '';
            return Column(
              children: [
                Text(
                  'Mã OTP đã gửi đến số điện thoại $phoneNumber',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                    color: AppColors.getTextColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                // Countdown timer hoặc Gửi lại OTP
                if (_remainingSeconds > 0)
                  Text(
                    'Thời gian: ${_remainingSeconds}s',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto Condensed',
                      fontWeight: FontWeight.w500,
                      color: AppColors.red,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _resendOTP,
                    child: const Text(
                      'Gửi lại OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w500,
                        color: AppColors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const Spacer(),
        // Button "Tiếp tục" nằm dưới cùng với SafeArea
        StreamBuilder<RegisterState>(
          stream: widget.controller.stateStream,
          builder: (context, snapshot) {
            final isLoading = snapshot.data?.isLoading ?? false;
            return Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF5691FF),
                    Color(0xFFDE50D0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: null, // OTP tự động submit khi nhập đủ
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Tiếp tục',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
