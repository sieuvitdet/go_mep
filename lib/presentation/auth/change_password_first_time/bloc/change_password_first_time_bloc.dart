import 'package:go_mep_application/common/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordFirstTimeBloc {
  // Controllers cho các trường nhập
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Stream lỗi cho từng trường
  final streamErrorUserName = BehaviorSubject<String?>();
  final streamErrorPassword = BehaviorSubject<String?>();
  final streamErrorConfirmPassword = BehaviorSubject<String?>();
  final streamEnableButton = BehaviorSubject<bool>();
  final streamGeneralError = BehaviorSubject<String?>();

  final BuildContext context;
  ChangePasswordFirstTimeBloc(this.context) {
    userNameController.addListener(validateEnableButton);
    passwordController.addListener(validateEnableButton);
    confirmPasswordController.addListener(validateEnableButton);
  }

  void validateEnableButton() {
    final enable = userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
    streamEnableButton.set(enable);
  }

  void onSubmit() {
    bool hasError = false;
    if (userNameController.text.isEmpty) {
      streamErrorUserName.set('Vui lòng nhập tên tài khoản');
      hasError = true;
    } else {
      streamErrorUserName.set(null);
    }
    if (passwordController.text.isEmpty) {
      streamErrorPassword.set('Vui lòng nhập mật khẩu');
      hasError = true;
    } else {
      streamErrorPassword.set(null);
    }
    if (confirmPasswordController.text.isEmpty) {
      streamErrorConfirmPassword.set('Vui lòng nhập lại mật khẩu');
      hasError = true;
    } else if (confirmPasswordController.text != passwordController.text) {
      streamErrorConfirmPassword.set('Mật khẩu không khớp');
      hasError = true;
    } else {
      streamErrorConfirmPassword.set(null);
    }
    if (!hasError) {
      streamGeneralError.set(null);
    }
  }

  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    streamErrorUserName.close();
    streamErrorPassword.close();
    streamErrorConfirmPassword.close();
    streamEnableButton.close();
    streamGeneralError.close();
  }
}
