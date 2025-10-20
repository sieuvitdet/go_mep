import 'dart:async';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';
import 'package:flutter/material.dart';

class AccountController {
  final _userInfoController = StreamController<UserMeResModel?>.broadcast();
  final _loadingController = StreamController<bool>.broadcast();

  Stream<UserMeResModel?> get userInfoStream => _userInfoController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  AccountController() {
    _loadingController.add(false);
  }

  void setUserInfo(UserMeResModel? user) {
    _userInfoController.add(user);
  }

  Future<void> onLogOut(BuildContext context) async {
    _loadingController.add(true);
    GoMepLoadingDialog.show(context);

    ResponseModel responseModel = await Repository.logout(context);

    GoMepLoadingDialog.hide(context);
    _loadingController.add(false);

    if (responseModel.success ?? false) {
      Globals.prefs.dispose();
      CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
    } else {
      if (responseModel.statusCode != 401) {
        await CustomNavigator.showCustomAlertDialog(
          context,
          "Vui lòng đăng nhập lại",
          title: "Đã có lỗi xảy ra!",
          type: CustomAlertDialogType.error,
          enableCancel: false,
          textSubmitted: "Đăng nhập lại",
          cancelable: false,
          onSubmitted: () async {
            CustomNavigator.pop(context);
            Globals.prefs.dispose();
            CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
          },
        );
      }
    }
  }

  void dispose() {
    _userInfoController.close();
    _loadingController.close();
  }
}
