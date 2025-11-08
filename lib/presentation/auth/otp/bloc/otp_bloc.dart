import 'dart:async';    
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/data/model/req/reset_password_request_req_model.dart';
import 'package:go_mep_application/presentation/auth/reset_password/ui/reset_password_screen.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:go_mep_application/common/utils/utility.dart';

class OtpBloc {
  BuildContext context;
  final String phoneNumber;

  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (index) => FocusNode());

  // Streams
  final streamOtpCode = BehaviorSubject<String>();
  final streamHasError = BehaviorSubject<bool>();
  final streamIsValid = BehaviorSubject<bool>();
  final streamCanResend = BehaviorSubject<bool>();
  final streamCountdown = BehaviorSubject<int>();
  final streamError = BehaviorSubject<String?>();

  // Timer
  Timer? _timer;
  int _countdown = 60;  

  // Validation flag to prevent duplicate API calls
  bool _isValidating = false;

  OtpBloc(this.context, this.phoneNumber) {
    _initializeStreams();
    _startCountdown();
  }

  void _initializeStreams() {
    streamOtpCode.add('');
    streamHasError.add(false);
    streamIsValid.add(false);
    streamCanResend.add(false);
    streamCountdown.add(_countdown);
  }

  void _startCountdown() {
    _countdown = 60;
    streamCanResend.add(false);
    streamCountdown.add(_countdown);

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _countdown--;
      streamCountdown.add(_countdown);

      if (_countdown <= 0) {
        timer.cancel();
        streamCanResend.add(true);
      }
    });
  }

  void onOtpChanged(String otp) {
    streamOtpCode.add(otp);
    streamHasError.add(false);
    streamIsValid.add(false);

    if (otp.length == 6) {
      _validateOtp(otp);
    }
  }

  void onOtpCompleted(String otp) {
    streamOtpCode.add(otp);
    if (otp.length == 6) {
      _validateOtp(otp);
    }
  }

  void _validateOtp(String otp) async {
    if (_isValidating) return; // Prevent duplicate calls
    _isValidating = true;

    Utility.hideKeyboard();

    try {
      ResponseModel responseModel = await Repository.verifyResetPassword(
        context,
        OtpVerifyReqModel(
          phoneNumber: phoneNumber,
          otp: otp,
        ),
      );

      if (responseModel.success ?? false) {
        streamIsValid.add(true);
        streamHasError.add(false);
        await Future.delayed(Duration(milliseconds: 2000));
            CustomNavigator.pushReplacement(
                context,
                ResetPasswordScreen(
                  phoneNumber: phoneNumber,
                ));
      } else {
        streamError.add(responseModel.message);

        streamHasError.add(true);
        streamIsValid.add(false);
        await Future.delayed(Duration(milliseconds: 2000));
        _clearOtp();
        _isValidating = false; // Reset flag on error
        streamError.add(null);
      }
    } catch (e) {
      GoMepLoadingDialog.hide(context);
      streamHasError.add(true);
      streamIsValid.add(false);
      Utility.toast("OTP không hợp lệ");
      _clearOtp();
      _isValidating = false; // Reset flag on exception
    }
  }

  void _clearOtp() {
    _isValidating = false; // Reset validation flag when clearing
    for (var controller in otpControllers) {
      controller.clear();
    }
    streamOtpCode.add('');
    streamHasError.add(false);
    streamIsValid.add(false);

    // Focus on first field
    otpFocusNodes[0].requestFocus();
  }

  void onResendOtp(String username) async {
    if (!(streamCanResend.valueOrNull ?? false)) return;
    Utility.hideKeyboard();
    GoMepLoadingDialog.show(context, message: "Lấy lại OTP");

    try {
      ResponseModel responseModel = await Repository.requestResetPassword(
        context,
        ResetPasswordRequestReqModel(
          phoneNumber: phoneNumber,
          resetType: 'PHONE',
        ),
      );
      GoMepLoadingDialog.hide(context);
      if (responseModel.success ?? false) {
        Utility.toast("Đã gửi lại mã OTP");
        _clearOtp();
        _startCountdown();
      }
    } catch (e) {
      GoMepLoadingDialog.hide(context);
      Utility.toast("Lấy lại mã OTP thất bại");
    }
  }

  void fillOtpManually(String otp) {
    if (otp.length != 6) return;

    for (int i = 0; i < 6; i++) {
      otpControllers[i].text = otp[i];
    }

    // Unfocus all fields
    for (var node in otpFocusNodes) {
      node.unfocus();
    }

    onOtpCompleted(otp);
  }

  String get currentOtp {
    return otpControllers.map((c) => c.text).join();
  }

  void dispose() {
    _timer?.cancel();

    for (var controller in otpControllers) {
      controller.dispose();
    }

    for (var node in otpFocusNodes) {
      node.dispose();
    }

    streamOtpCode.close();
    streamHasError.close();
    streamIsValid.close();
    streamCanResend.close();
    streamCountdown.close();
  }
}
