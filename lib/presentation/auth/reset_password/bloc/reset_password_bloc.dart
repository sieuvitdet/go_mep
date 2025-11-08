import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/data/model/req/reset_password_req_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';
import 'package:rxdart/rxdart.dart';

class UserAccount {
  final String username;
  final String fullName;

  UserAccount({required this.username, required this.fullName});
}

class ResetPasswordBloc {
  late BuildContext context;
  ResetPasswordBloc(BuildContext context) {
    this.context = context;
    passwordNewController.addListener(validateEnableSubmit);
    confirmPasswordNewController.addListener(validateEnableSubmit);
  }

  final streamErrorPasswordOld = BehaviorSubject<String?>();
  final streamErrorPasswordNew = BehaviorSubject<String?>();
  final streamErrorConfirmPasswordNew = BehaviorSubject<String?>();
  final streamEnableSubmit = BehaviorSubject<bool>();

  TextEditingController passwordNewController = TextEditingController();
  TextEditingController confirmPasswordNewController = TextEditingController();
  FocusNode passwordNewNode = FocusNode();
  FocusNode confirmPasswordNewNode = FocusNode();

  bool isShowPasswordNew = false;
  bool isShowPasswordConfirmNew = false;
  final streamShowPasswordNew = BehaviorSubject<bool>();
  final streamShowPasswordConfirmNew = BehaviorSubject<bool>();

  void onShowPasswordNew() {
    isShowPasswordNew = !isShowPasswordNew;
    streamShowPasswordNew.set(isShowPasswordNew);
  }

  void onShowPasswordConfirmNew() {
    isShowPasswordConfirmNew = !isShowPasswordConfirmNew;
    streamShowPasswordConfirmNew.set(isShowPasswordConfirmNew);
  }

  void validateEnableSubmit() {
    final enable = passwordNewController.text.isNotEmpty &&
        confirmPasswordNewController.text.isNotEmpty;
    streamEnableSubmit.set(enable);
  }

  void dispose() {
    passwordNewController.dispose();
    confirmPasswordNewController.dispose();
    passwordNewNode.dispose();
    confirmPasswordNewNode.dispose();
    streamErrorPasswordNew.close();
    streamErrorConfirmPasswordNew.close();
    streamEnableSubmit.close();
    streamShowPasswordNew.close();
    streamShowPasswordConfirmNew.close();
  }

  bool validatePassword() {
    bool isError = false;
    final confirmPassword = passwordNewController.text;
    final confirmPasswordNew = confirmPasswordNewController.text;
    if (!Utility.isPassword(confirmPassword)) {
      streamErrorPasswordNew.set(
          "Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt");
      isError = true;
    } else {
      streamErrorPasswordNew.set(null);
    }
    if (!Utility.isPassword(confirmPasswordNew)) {
      streamErrorConfirmPasswordNew.set(
          "Mật khẩu xác nhận phải có ít nhất 8 ký tự, bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt");
      isError = true;
    } else {
      streamErrorConfirmPasswordNew.set(null);
    }

    if (passwordNewController.text != confirmPasswordNewController.text) {
      streamErrorConfirmPasswordNew
          .set("Mật khẩu và xác nhận mật khẩu không khớp");
      isError = true;
    } else {
      streamErrorConfirmPasswordNew.set(null);
    }

    return isError;
  }

  onSubmit() async {
    if (validatePassword()) {
      return;
    }
    try {
      GoMepLoadingDialog.show(context, message: "Đang đặt lại mật khẩu");
      // ResponseModel responseModel = await Repository.resetPassword(
      //   context,
      //   ResetPasswordReqModel(
      //     newPassword: passwordNewController.text,
      //     confirmPassword: confirmPasswordNewController.text,
      //   ),
      // );

      await Future.delayed(const Duration(seconds: 1));
      GoMepLoadingDialog.hide(context);

      CustomNavigator.popToRootAndPushReplacement(
                  context, LoginScreen(),);

      // if (responseModel.success ?? false) {
      //   if (context.mounted) {
      //     await Utility.toast("Tạo mật khẩu mới thành công!");
      //     await Future.delayed(Duration(seconds: 1));
      //     CustomNavigator.popToRootAndPushReplacement(
      //             context, LoginScreen(),);
      //   }
      // }
    } catch (e) {
      GoMepLoadingDialog.hide(context);
      Utility.toast("Đặt lại mật khẩu thất bại");
    }
  }
}