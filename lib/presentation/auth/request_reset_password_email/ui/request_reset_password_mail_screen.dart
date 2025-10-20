import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/res/account_check_res_model.dart';
import 'package:go_mep_application/presentation/auth/request_reset_password_email/bloc/request_reset_password_mail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';

class RequestResetPasswordMailScreen extends StatefulWidget {
  const RequestResetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<RequestResetPasswordMailScreen> createState() =>
      _RequestResetPasswordMailScreenState();
}

class _RequestResetPasswordMailScreenState
    extends State<RequestResetPasswordMailScreen> {
  late RequestResetPasswordMailBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RequestResetPasswordMailBloc(context);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_sharp, color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppLocalizations.text(LangKey.reset_password),
                fontSize: AppTextSizes.subHeader,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              Gaps.vGap8,
              CustomText(
                text: AppLocalizations.text(
                    LangKey.please_enter_email_below_follow_instructions),
                fontSize: AppTextSizes.body,
                color: AppColors.black,
              ),
              Gaps.vGap16,
              StreamBuilder<String?>(
                stream: bloc.streamErrorAccount,
                builder: (context, snapshot) {
                  return CustomTextField(
                    controller: bloc.accountController,
                    focusNode: bloc.accountNode,
                    hintText: "Tìm theo email",
                    errorMessage: snapshot.data,
                    prefixIconWidget: InkWell(
                      onTap: () {
                        bloc.onGetUserCheck();
                      },
                      child:
                          Image.asset(Assets.iconSearch, width: 20, height: 20),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 20,
                    ),
                  );
                },
              ),
              StreamBuilder<AccountCheckResModel?>(
                stream: bloc.streamAccountCheck.output,
                initialData: null,
                builder: (context, snapshot) {
                  AccountCheckResModel? accountCheckResModel = snapshot.data;
                  return accountCheckResModel != null
                      ? buildInfoUser(accountCheckResModel)
                      : SizedBox.shrink();
                },
              ),
              Gaps.vGap16,
              Spacer(),
              StreamBuilder<bool>(
                stream: bloc.streamLoading,
                builder: (context, loadingSnapshot) {
                  final isLoading = loadingSnapshot.data ?? false;

                  return StreamBuilder<bool>(
                    stream: bloc.streamEnableSubmit,
                    builder: (context, snapshot) {
                      final isEnabled = snapshot.data ?? false;

                      return CustomButton(
                        enable: isEnabled,
                        text: isLoading
                            ? AppLocalizations.text(LangKey.sending_ellipsis)
                            : AppLocalizations.text(LangKey.confirm),
                        onTap: isEnabled && !isLoading ? bloc.onSubmit : null,
                        textColor: isEnabled ? AppColors.white : AppColors.hint,
                      );
                    },
                  );
                },
              ),
              Gaps.vGap16,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoUser(AccountCheckResModel accountCheckResModel) {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.small),
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.small, vertical: AppSizes.regular),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.small),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.small),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          Gaps.hGap8,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: accountCheckResModel.fullName ?? "",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              if (accountCheckResModel.maskedEmail?.isNotEmpty ?? false) ...[
                CustomText(
                  text: accountCheckResModel.maskedEmail ?? "",
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
