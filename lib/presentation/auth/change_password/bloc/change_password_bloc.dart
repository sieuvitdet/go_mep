import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc {
  late BuildContext context;
  ChangePasswordBloc(BuildContext context) {
    this.context = context;
    passwordOldController.addListener(validateEnableButton);
    passwordNewController.addListener(validateEnableButton);
    confirmPasswordNewController.addListener(validateEnableButton);
  }

  void dispose() {
    streamErrorPasswordOld.close();
    streamErrorPasswordNew.close();
    streamErrorConfirmPasswordNew.close();
    streamEnableLogin.close();
    streamShowPasswordNew.close();
    streamShowPasswordConfirmNew.close();
    streamShowPasswordOld.close();
  }

  final streamErrorPasswordOld = BehaviorSubject<String?>();
  final streamErrorPasswordNew = BehaviorSubject<String?>();
  final streamErrorConfirmPasswordNew = BehaviorSubject<String?>();
  final streamEnableLogin = BehaviorSubject<bool>();

  TextEditingController passwordOldController = TextEditingController();
  TextEditingController passwordNewController = TextEditingController();
  TextEditingController confirmPasswordNewController = TextEditingController();
  FocusNode passwordOldNode = FocusNode();
  FocusNode passwordNewNode = FocusNode();
  FocusNode confirmPasswordNewNode = FocusNode();

  bool isShowPasswordNew = false;
  bool isShowPasswordConfirmNew = false;
  bool isShowPasswordOld = false;
  final streamShowPasswordNew = BehaviorSubject<bool>();
  final streamShowPasswordConfirmNew = BehaviorSubject<bool>();
  final streamShowPasswordOld = BehaviorSubject<bool>();

  void onShowPasswordOld() {
    isShowPasswordOld = !isShowPasswordOld;
    streamShowPasswordOld.set(isShowPasswordOld);
  }

  void onShowPasswordNew() {
    isShowPasswordNew = !isShowPasswordNew;
    streamShowPasswordNew.set(isShowPasswordNew);
  }

  void onShowPasswordConfirmNew() {
    isShowPasswordConfirmNew = !isShowPasswordConfirmNew;
    streamShowPasswordConfirmNew.set(isShowPasswordConfirmNew);
  }

  void validateEnableButton() {
    streamEnableLogin.set(passwordOldController.text.isNotEmpty &&
        passwordNewController.text.isNotEmpty &&
        confirmPasswordNewController.text.isNotEmpty &&
        (streamErrorPasswordOld.valueOrNull == null) &&
        (streamErrorPasswordNew.valueOrNull == null) &&
        (streamErrorConfirmPasswordNew.valueOrNull == null));
  }

  bool validatePassword() {
    bool isError = false;
    final password = passwordOldController.text;
    final confirmPassword = passwordNewController.text;
    final confirmPasswordNew = confirmPasswordNewController.text;

    if (!Utility.isPassword(password)) {
      streamErrorPasswordOld.set(
          "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt");
      isError = true;
    } else {
      streamErrorPasswordOld.set(null);
    }
    if (!Utility.isPassword(confirmPassword)) {
      streamErrorPasswordNew.set(
          "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt");
      isError = true;
    } else {
      streamErrorPasswordNew.set(null);
    }
    if (!Utility.isPassword(confirmPasswordNew)) {
      streamErrorConfirmPasswordNew.set(
          "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt");
      isError = true;
    } else {
      streamErrorConfirmPasswordNew.set(null);
    }
    return isError;
  }

  void onSubmit() async {
    bool hasError = false;
    if (passwordOldController.text.isEmpty) {
      streamErrorPasswordOld
          .set(AppLocalizations.text(LangKey.please_enter_old_password));
      hasError = true;
    }
    if (passwordNewController.text.isEmpty) {
      streamErrorPasswordNew
          .set(AppLocalizations.text(LangKey.please_enter_new_password));
      hasError = true;
    }
    if (confirmPasswordNewController.text.isEmpty) {
      streamErrorConfirmPasswordNew
          .set(AppLocalizations.text(LangKey.reenter_new_password));
      hasError = true;
    }
    if (!hasError) {
      if (validatePassword()) {
        return;
      }
    }
    if (passwordNewController.text != confirmPasswordNewController.text) {
      streamErrorConfirmPasswordNew
          .set(AppLocalizations.text(LangKey.new_password_mismatch));
      hasError = true;
    }
    if (!hasError) {
      GoMepLoadingDialog.show(context, message: "Đang đổi mật khẩu");
      await Future.delayed(const Duration(seconds: 2));
      // ResponseModel responseModel = await Repository.changePassword(
      //   context,
      //   ChangePasswordReqModel(
      //     currentPassword: passwordOldController.text,
      //     newPassword: passwordNewController.text,
      //     confirmPassword: confirmPasswordNewController.text,
      //   ),
      // );
      GoMepLoadingDialog.hide(context);
      CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
      // if (responseModel.success ?? false) {
      //   ChangePasswordResModel changePasswordResModel =
      //       ChangePasswordResModel.fromJson(responseModel.result ?? {});
      //   CustomNavigator.showCustomAlertDialog(
      //     context,
      //     changePasswordResModel.message ??
      //         AppLocalizations.text(LangKey.password_changed_success_message),
      //     type: CustomAlertDialogType.success,
      //     enableCancel: false,
      //     textSubmitted: AppLocalizations.text(LangKey.close),
      //     onSubmitted: () {
      //       Globals.prefs
      //           .setBool(SharedPrefsKey.is_require_password_change, false);
      //       Globals.prefs.setString(SharedPrefsKey.token, "");
      //       CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
      //     },
      //   );
      // }
    }
  }
}
