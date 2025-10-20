import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/req/reset_password_request_req_model.dart';
import 'package:go_mep_application/data/model/res/account_check_res_model.dart';
import 'package:go_mep_application/data/model/res/reset_password_request_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RequestResetPasswordMailBloc {
  TextEditingController accountController = TextEditingController();
  FocusNode accountNode = FocusNode();

  final streamErrorAccount = BehaviorSubject<String?>();
  final streamEnableSubmit = BehaviorSubject<bool>();
  final streamLoading = BehaviorSubject<bool>();
  final streamAccountCheck = BehaviorSubject<AccountCheckResModel?>();

  late BuildContext context;

  RequestResetPasswordMailBloc(BuildContext context) {
    this.context = context;
    streamEnableSubmit.set(false);
    streamLoading.set(false);
  }

  void dispose() {
    accountController.dispose();
    accountNode.dispose();
    streamErrorAccount.close();
    streamEnableSubmit.close();
    streamLoading.close();
    streamAccountCheck.close();
  }

  onGetUserCheck() async {
    if (validateEmail()) {
      return;
    }
    if (accountController.text.isEmpty) {
      streamErrorAccount
          .set(AppLocalizations.text(LangKey.please_enter_username));
      return;
    }
    streamLoading.set(true);
    ResponseModel responseModel =
        await Repository.accountCheck(context, accountController.text);

    if (responseModel.success ?? false) {
      AccountCheckResModel accountCheckResModel =
          AccountCheckResModel.fromJson(responseModel.result ?? {});

      if (accountCheckResModel.username != null) {
        streamAccountCheck.set(accountCheckResModel);
        streamEnableSubmit.set(true);
      } else {
        streamErrorAccount.set(AppLocalizations.text(LangKey.account_invalid));
        streamEnableSubmit.set(false);
      }
    }
  }

  bool validateEmail() {
    bool isError = false;
    final email = accountController.text;
    if (!Utility.isEmail(email)) {
      streamErrorAccount.set("Email không hợp lệ");
      isError = true;
    } else {
      streamErrorAccount.set(null);
    }
    return isError;
  }

  onSubmit() async {
    if (accountController.text.isEmpty) {
      streamErrorAccount
          .set(AppLocalizations.text(LangKey.please_enter_username));
      return;
    }

    GoMepLoadingDialog.show(context, message: "Đang gửi email");

    try {
      ResponseModel responseModel = await Repository.requestResetPassword(
        context,
        ResetPasswordRequestReqModel(
          username: accountController.text,
          resetType: 'EMAIL',
        ),
      );
      GoMepLoadingDialog.hide(context);

      if (responseModel.success ?? false) {
        ResetPasswordRequestResModel resetPasswordRequestResModel =
            ResetPasswordRequestResModel.fromJson(responseModel.result ?? {});

        // Show success message
        if (context.mounted) {
          CustomNavigator.showCustomAlertDialog(
            context,
            resetPasswordRequestResModel.message ??
                AppLocalizations.text(LangKey.account_sent_it_will_contact),
            title: AppLocalizations.text(LangKey.send_account_success_title),
            type: CustomAlertDialogType.success,
            enableCancel: false,
            textSubmitted: AppLocalizations.text(LangKey.back),
            onSubmitted: () {
              CustomNavigator.pop(context);
              CustomNavigator.pop(context, object: true);
            },
            cancelable: false,
          );
        }
      }
    } catch (e) {
      streamErrorAccount
          .set(AppLocalizations.text(LangKey.generic_error_try_again));
    } finally {}
  }
}
