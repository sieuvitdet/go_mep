import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/rsa_encryption_helper.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/req/reset_password_req_model.dart';
import 'package:go_mep_application/data/model/res/reset_password_res_model.dart';
import 'package:go_mep_application/data/model/res/reset_token_info_res_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UserAccount {
  final String username;
  final String fullName;

  UserAccount({required this.username, required this.fullName});
}

class ResetPasswordBloc {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode accountNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  final streamErrorAccount = BehaviorSubject<String?>();
  final streamErrorPassword = BehaviorSubject<String?>();
  final streamErrorConfirmPassword = BehaviorSubject<String?>();
  final streamEnableSubmit = BehaviorSubject<bool>();
  final streamLoading = BehaviorSubject<bool>();
  final streamSearchResults = BehaviorSubject<List<UserAccount>>();
  final streamShowSearchResults = BehaviorSubject<bool>();
  final streamShowPasswordFields = BehaviorSubject<bool>();
  final streamResetToken = BehaviorSubject<String?>();

  late BuildContext context;

  // Mock data
  final List<UserAccount> mockUsers = [
    UserAccount(username: 'ANVN', fullName: 'Nguyễn Văn An'),
    UserAccount(username: 'BVHN', fullName: 'Bùi Văn Hùng'),
    UserAccount(username: 'NVTB', fullName: 'Nguyễn Văn Thái Bình'),
    UserAccount(username: 'LTHN', fullName: 'Lê Thị Hồng Nhung'),
    UserAccount(username: 'PVDN', fullName: 'Phạm Văn Đức Nam'),
    UserAccount(username: 'TTAN', fullName: 'Trần Thị An'),
    UserAccount(username: 'NVKH', fullName: 'Nguyễn Văn Khánh'),
    UserAccount(username: 'LMDT', fullName: 'Lê Minh Đức Tài'),
  ];

  ResetPasswordBloc(BuildContext context) {
    this.context = context;
    streamEnableSubmit.set(false);
    streamLoading.set(false);
    streamShowSearchResults.set(false);
    streamShowPasswordFields.set(false);
    accountController.addListener(() {
      validateEnableSubmit();
      searchUsers(accountController.text);
    });
    passwordController.addListener(validateEnableSubmit);
    confirmPasswordController.addListener(validateEnableSubmit);
    accountNode.addListener(() {
      if (accountNode.hasFocus) {
        streamShowSearchResults.set(true);
      }
    });
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      streamSearchResults.set([]);
      streamShowSearchResults.set(false);
      return;
    }

    final results = mockUsers.where((user) {
      return user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.fullName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    streamSearchResults.set(results);
    streamShowSearchResults.set(results.isNotEmpty);
  }

  void selectUser(UserAccount user) {
    accountController.text = user.username;
    streamShowSearchResults.set(false);
    validateEnableSubmit();
  }

  void validateEnableSubmit() {
    if (streamShowPasswordFields.value) {
      final enable = accountController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
      streamEnableSubmit.set(enable);
    } else {
      final enable = accountController.text.isNotEmpty;
      streamEnableSubmit.set(enable);
    }
  }

  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    accountNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    streamErrorAccount.close();
    streamErrorPassword.close();
    streamErrorConfirmPassword.close();
    streamEnableSubmit.close();
    streamLoading.close();
    streamSearchResults.close();
    streamShowSearchResults.close();
    streamShowPasswordFields.close();
    streamResetToken.close();
  }

  onSubmit() async {
    if (accountController.text.isEmpty) {
      streamErrorAccount
          .set(AppLocalizations.text(LangKey.please_enter_username));
      return;
    }

    if (streamShowPasswordFields.value) {
      if (passwordController.text != confirmPasswordController.text) {
        streamErrorConfirmPassword
            .set(AppLocalizations.text(LangKey.new_password_mismatch));
        return;
      }

      streamLoading.set(true);

      try {
        final encryptedNewPassword = await RsaPem.encryptPassword(
          password: passwordController.text,
        );
        final encryptedConfirmPassword = await RsaPem.encryptPassword(
          password: confirmPasswordController.text,
        );

        ResponseModel responseModel = await Repository.resetPassword(
          context,
          ResetPasswordReqModel(
            deviceId: await Utility.getDeviceId(),
            deviceName: await Utility.getModelDevice(),
            devicePlatform: await Utility.getDevicePlatform(),
            appVersion: "1.0.0",
            resetToken: streamResetToken.value ?? "",
            newPassword: encryptedNewPassword,
            confirmPassword: encryptedConfirmPassword,
          ),
        );

        if (responseModel.success ?? false) {
          ResetPasswordResModel resetPasswordResModel =
              ResetPasswordResModel.fromJson(responseModel.result ?? {});

          if (context.mounted) {
            CustomNavigator.showCustomAlertDialog(
              context,
              resetPasswordResModel.message ??
                  AppLocalizations.text(LangKey.password_reset_success_message),
              title:
                  AppLocalizations.text(LangKey.password_reset_success_title),
              type: CustomAlertDialogType.success,
              enableCancel: false,
              textSubmitted: AppLocalizations.text(LangKey.login),
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
      } finally {
        streamLoading.set(false);
      }
    } else {
      // Request reset password - get reset token info
      streamLoading.set(true);

      try {
        ResponseModel responseModel = await Repository.resetTokenInfo(context);

        if (responseModel.success ?? false) {
          ResetTokenInfoResModel resetTokenInfoResModel =
              ResetTokenInfoResModel.fromJson(responseModel.result ?? {});

          if (resetTokenInfoResModel.resetToken != null) {
            // Store the reset token
            streamResetToken.set(resetTokenInfoResModel.resetToken);
            streamShowPasswordFields.set(true);

            // Check if token is expired
            if (resetTokenInfoResModel.resetPasswordTokenExpiry != null &&
                resetTokenInfoResModel.resetPasswordTokenExpiry!
                    .isBefore(DateTime.now())) {
              streamErrorAccount
                  .set(AppLocalizations.text(LangKey.otp_expired_request_new));
              streamShowPasswordFields.set(false);
              return;
            }

            if (context.mounted) {
              CustomNavigator.showCustomAlertDialog(
                context,
                AppLocalizations.text(LangKey.hello) +
                    ' ${resetTokenInfoResModel.fullName ?? resetTokenInfoResModel.username ?? ""}. ' +
                    AppLocalizations.text(LangKey.please_enter_new_password),
                type: CustomAlertDialogType.info,
                enableCancel: false,
                textSubmitted: AppLocalizations.text(LangKey.confirm),
              );
            }
          } else {
            streamErrorAccount
                .set(AppLocalizations.text(LangKey.otp_not_found_contact_it));
          }
        }
      } catch (e) {
        streamErrorAccount
            .set(AppLocalizations.text(LangKey.generic_error_try_again));
      } finally {
        streamLoading.set(false);
      }
    }
  }
}
