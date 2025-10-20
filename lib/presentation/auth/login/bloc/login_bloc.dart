
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/data/model/res/test_encrypt_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/presentation/main/ui/main_screen.dart';
import 'package:go_mep_application/presentation/auth/register/ui/register_screen.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  bool isShowPassword = false;

  final streamErrorUserName = BehaviorSubject<String?>();
  final streamErrorPassword = BehaviorSubject<String?>();
  final streamObscureText = BehaviorSubject<bool>();
  final streamEnableLogin = BehaviorSubject<bool>();
  final streamEnableSavePassword = BehaviorSubject<bool>();
  final streamShowPassword = BehaviorSubject<bool>();

  late BuildContext context;
  LoginBloc(BuildContext context) {
    this.context = context;
    streamEnableLogin.set(false);
    streamEnableSavePassword.set(false);
    streamObscureText.set(true);
    userNameController.addListener(validateEnableLogin);
    passwordController.addListener(validateEnableLogin);
    streamShowPassword.set(false);
  }

  void onShowPassword() {
    isShowPassword = !isShowPassword;
    streamShowPassword.set(isShowPassword);
  }

  void validateEnableLogin() {
    final enable = userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    streamEnableLogin.set(enable);
  }

  bool validatePassword() {
    bool isError = false;
    final password = passwordController.text;
    if (!Utility.isPassword(password)) {
      streamErrorPassword.set(
          "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt");
      isError = true;
    } else {
      streamErrorPassword.set(null);
    }
    return isError;
  }

  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    userNameNode.dispose();
    passwordNode.dispose();
    streamErrorUserName.close();
    streamErrorPassword.close();
    streamEnableSavePassword.close();
    streamEnableLogin.close();
    streamObscureText.close();
  }

  onGetEncryptedPassword() async {
    try {
      final password = passwordController.text.trim();
      if (password.isEmpty) {
        Utility.toast("Vui lòng nhập mật khẩu");
        return null;
      }

      ResponseModel responseModel = await Repository.testEncrypt(
        context,
        password,
        showError: false,
      );

      if (responseModel.success == true) {
        TestEncryptResModel encryptResponse = 
            TestEncryptResModel.fromJson(responseModel.result ?? {});
        return encryptResponse.result ?? "";
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  onLogin() async {
    CustomNavigator.push(context, MainScreen());
  }

  onForgotPassword() async {
  }

  onRegister() {
    CustomNavigator.push(context, const RegisterScreen());
  }

  onSavePassword() {}
}
