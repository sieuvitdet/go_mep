import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/common/widgets/custom_otp_textfield.dart';
import 'package:go_mep_application/presentation/auth/otp/bloc/otp_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String? phoneNumber;

  const OtpScreen({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with WidgetsBindingObserver {
  late OtpBloc _bloc;
  late bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc =
        OtpBloc(context, widget.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _bloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    final visible = bottomInset > 0.0;
    if (visible != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: AppColors.getBackgroundColor(context),
          appBar: AppBar(
          backgroundColor: AppColors.getBackgroundColor(context),
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back_sharp, color: AppColors.getTextColor(context)),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Nhập mã OTP",
                  fontSize: AppTextSizes.subHeader,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextColor(context),
                ),
      
                Gaps.vGap6,
      
                // OTP instruction
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.getTextColor(context),
                      fontFamily: 'BeVietnamPro',
                    ),
                    children: [
                      TextSpan(
                        text: "Vui lòng nhập mã OTP đã được gửi đến email ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.getTextColor(context),
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                      TextSpan(
                        text: widget.phoneNumber ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.getTextColor(context),
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                      TextSpan(
                        text: " để tiếp tục!",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.getTextColor(context),
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                    ],
                  ),
                ),
      
                Gaps.vGap24,
                StreamBuilder<bool>(
                  stream: _bloc.streamHasError,
                  builder: (context, hasErrorSnapshot) {
                    return StreamBuilder<bool>(
                      stream: _bloc.streamIsValid,
                      builder: (context, isValidSnapshot) {
                        final isValid = isValidSnapshot.data ?? false;
      
                        return CustomOtpTextField(
                          length: 6,
                          controllers: _bloc.otpControllers,
                          focusNodes: _bloc.otpFocusNodes,
                          hasError: hasErrorSnapshot.data ?? false,
                          isValid: isValid,
                          onChanged: _bloc.onOtpChanged,
                          onCompleted: _bloc.onOtpCompleted,
                        );
                      },
                    );
                  },
                ),

                StreamBuilder<String?>(
                  stream: _bloc.streamError,
                  builder: (context, errorSnapshot) {
                    if (errorSnapshot.hasData && errorSnapshot.data != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                        child: CustomText(
                          text: errorSnapshot.data!,
                          fontSize: AppTextSizes.body,
                          fontWeight: FontWeight.w500,
                          color: AppColors.red,
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                Gaps.vGap32,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Chưa nhận được OTP?  ",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.getTextColor(context),
                    ),
                    StreamBuilder<bool>(
                      stream: _bloc.streamCanResend,
                      builder: (context, canResendSnapshot) {
                        return StreamBuilder<int>(
                          stream: _bloc.streamCountdown,
                          builder: (context, countdownSnapshot) {
                            final canResend = canResendSnapshot.data ?? false;
                            final countdown = countdownSnapshot.data ?? 300;
      
                            if (canResend) {
                              return InkWell(
                                onTap: () => _bloc.onResendOtp(
                                    widget.phoneNumber ?? ""),
                                child: CustomText(
                                  text: "Lấy lại OTP",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              );
                            } else {
                              return CustomText(
                                text: "Lấy lại OTP (${countdown}s)",
                                fontSize: 14,
                                color: AppColors.getTextColor(context),
                              );
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
      
                Gaps.vGap24,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
