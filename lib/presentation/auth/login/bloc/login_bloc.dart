
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs_key.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/presentation/auth/profile_completion/ui/profile_completion_screen.dart';
import 'package:go_mep_application/presentation/auth/request_reset_password_phone/ui/request_reset_password_mail_screen.dart';
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
    try {
      final phoneNumber = userNameController.text.trim();
      final password = passwordController.text.trim();

      if (phoneNumber.isEmpty || password.isEmpty) {
        Utility.toast('Vui lòng nhập đầy đủ thông tin đăng nhập');
        return;
      }

      GoMepLoadingDialog.show(context);

      final authRepo = Globals.authRepository;
      if (authRepo == null) {
        GoMepLoadingDialog.hide(context);
        Utility.toast('Lỗi hệ thống, vui lòng thử lại');
        return;
      }

      final user = await authRepo.login(
        phoneNumber: phoneNumber,
        password: password,
      );

      GoMepLoadingDialog.hide(context);

      if (user != null) {
        await Globals.userRepository?.cacheUser(user);
        Globals.prefs.setString(SharedPrefsKey.token, "local_auth_token");
        Globals.userMeResModel = user;

        final isProfileCompleted = Globals.prefs.getBool(SharedPrefsKey.is_profile_completed);

        if (isProfileCompleted == false) {
          CustomNavigator.push(context, const ProfileCompletionScreen());
        } else {
          CustomNavigator.push(context, MainScreen());
        }
      } else {
        Utility.toast('Số điện thoại hoặc mật khẩu không đúng');
      }
    } catch (e) {
      GoMepLoadingDialog.hide(context);
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
