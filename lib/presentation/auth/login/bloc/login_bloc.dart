
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs_key.dart';
import 'package:go_mep_application/data/model/req/login_req_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/presentation/auth/change_password/ui/change_password_screen.dart';
import 'package:go_mep_application/presentation/auth/request_reset_password_phone/ui/request_reset_password_mail_screen.dart';
import 'package:go_mep_application/presentation/auth/reset_password/ui/reset_password_screen.dart';
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

  onLogin() async {
    //  CustomNavigator.push(context, MainScreen());
    try {
      final phoneNumber = userNameController.text.trim();
      final password = passwordController.text.trim();
      
      if (phoneNumber.isEmpty || password.isEmpty) {
        Utility.toast('Vui lòng nhập đầy đủ thông tin đăng nhập');
        return;
      }
      GoMepLoadingDialog.show(context);
      await Future.delayed(const Duration(seconds: 3));

      final loginModel = LoginReqModel(
        phoneNumber: phoneNumber,
        password: password,
      );

      ResponseModel responseModel = await Repository.login(context, loginModel);

      GoMepLoadingDialog.hide(context);
      Globals.prefs.setString(SharedPrefsKey.token, "test");
       CustomNavigator.push(context, MainScreen());

      // if (responseModel.success ?? false) {
      //   Globals.prefs.setString(SharedPrefsKey.token, responseModel.result?['access_token'] ?? '');

      //   CustomNavigator.push(context, MainScreen());
      // } 
    } catch (e) {
      Utility.toast('Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  onForgotPassword() async {
    CustomNavigator.push(context,  RequestResetPasswordPhoneScreen());
  }

  onRegister() {
    CustomNavigator.push(context, const RegisterScreen());
  }

  onSavePassword() {}
}
