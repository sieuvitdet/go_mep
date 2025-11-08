import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/dialogs/gomep_loading_dialog.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/req/reset_password_request_req_model.dart';
import 'package:go_mep_application/data/model/res/reset_password_request_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:go_mep_application/presentation/auth/otp/ui/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RequestResetPasswordPhoneBloc {
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneNode = FocusNode();

  final streamErrorAccount = BehaviorSubject<String?>();
  final streamEnableSearch = BehaviorSubject<bool>();
  final streamEnableSubmit = BehaviorSubject<bool>();
  final streamAccountCheck = BehaviorSubject<ResetPasswordRequestResModel?>();
  final streamSelectedAccount = BehaviorSubject<bool>.seeded(false);

  late BuildContext context;

  RequestResetPasswordPhoneBloc(BuildContext context) {
    this.context = context;
    streamEnableSubmit.set(false);
    streamEnableSearch.set(false);
    phoneController.addListener(validateEnableSubmit);
  }

  void validateEnableSubmit() {
    final enable = phoneController.text.isNotEmpty && Utility.isPhoneNumber(phoneController.text);
    streamEnableSubmit.set(enable);
  }

  void dispose() {
    phoneController.dispose();
    phoneNode.dispose();
    streamEnableSubmit.close();
    streamAccountCheck.close();
    streamEnableSearch.close();
  }

  onSelectedAccount() {
    streamSelectedAccount.set(!streamSelectedAccount.value);
    streamEnableSubmit.set(streamSelectedAccount.value);
  }
  
  onSubmit(String phoneNumber) async {
    GoMepLoadingDialog.show(context, message: "Đang gửi OTP");

    try {
      // ResponseModel responseModel = await Repository.requestResetPassword(
      //   context,
      //   ResetPasswordRequestReqModel(
      //     phoneNumber: phoneNumber,
      //     resetType: 'PHONE',
      //   ),
      // );
      await Future.delayed(Duration(seconds: 2));
      GoMepLoadingDialog.hide(context);

      CustomNavigator.showCustomAlertDialog(
            context,
            "Chúng tôi đã gửi OTP đến số điện thoại của bạn. Vui lòng kiểm tra số điện thoại đến và làm theo hướng dẫn!",
            title: "Kiểm tra số điện thoại của bạn!",
            type: CustomAlertDialogType.info,
            enableCancel: false,
            textSubmitted: AppLocalizations.text(LangKey.confirm),
            onSubmitted: () {
              CustomNavigator.pop(context);
              CustomNavigator.pushReplacement(context,
                  OtpScreen(phoneNumber: phoneNumber));
            },
            cancelable: false,
          );

      // if (responseModel.success ?? false) {
      //   if (context.mounted) {
      //     CustomNavigator.showCustomAlertDialog(
      //       context,
      //       "Chúng tôi đã gửi OTP đến số điện thoại của bạn. Vui lòng kiểm tra số điện thoại đến và làm theo hướng dẫn!",
      //       title: "Kiểm tra số điện thoại của bạn!",
      //       type: CustomAlertDialogType.info,
      //       enableCancel: false,
      //       textSubmitted: AppLocalizations.text(LangKey.confirm),
      //       onSubmitted: () {
      //         CustomNavigator.pop(context);
      //         CustomNavigator.pushReplacement(context,
      //             OtpScreen(phoneNumber: phoneNumber));
      //       },
      //       cancelable: false,
      //     );
      //   }
      // }
    } catch (e) {
      streamErrorAccount
          .set(AppLocalizations.text(LangKey.generic_error_try_again));
    } finally {}
  }
}
