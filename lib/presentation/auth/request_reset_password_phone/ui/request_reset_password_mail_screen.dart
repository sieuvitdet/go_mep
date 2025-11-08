import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/res/reset_password_request_res_model.dart';
import 'package:go_mep_application/presentation/auth/request_reset_password_phone/bloc/request_reset_password_mail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';

class RequestResetPasswordPhoneScreen extends StatefulWidget {
  const RequestResetPasswordPhoneScreen({Key? key}) : super(key: key);

  @override
  State<RequestResetPasswordPhoneScreen> createState() =>
      _RequestResetPasswordPhoneScreenState();
}

class _RequestResetPasswordPhoneScreenState
    extends State<RequestResetPasswordPhoneScreen> {
  late RequestResetPasswordPhoneBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RequestResetPasswordPhoneBloc(context);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_sharp, color: AppColors.getTextColor(context)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppLocalizations.text(LangKey.reset_password),
                fontSize: AppTextSizes.subHeader,
                fontWeight: FontWeight.w700,
                color: AppColors.getTextColor(context),
              ),
              Gaps.vGap8,
              CustomText(
                text: "Vui lòng nhập số điện thoại của bạn phía dưới và xác nhận",
                fontSize: AppTextSizes.body,
                color: AppColors.getTextColor(context),
              ),
              Gaps.vGap16,
              StreamBuilder<String?>(
                stream: bloc.streamErrorAccount,
                builder: (context, snapshot) {
                  return StreamBuilder(
                      stream: bloc.streamEnableSearch,
                      builder: (context, asyncSnapshot) {
                        final enableSearch = asyncSnapshot.data ?? false;
                        return CustomTextField(
                          backgroundColor: AppColors.getBackgroundColor(context),
                          textInputColor: AppColors.getTextColor(context),
                          maxLines: 1,
                          maxLength: 15,
                          controller: bloc.phoneController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            bloc.onSubmit(value);
                          },
                          focusNode: bloc.phoneNode,
                          hintText: "Nhập số điện thoại",
                          errorMessage: snapshot.data,
                          onChanged: (value) {
                            bloc.streamEnableSearch.set(value.isNotEmpty);
                          },
                          prefixIconWidget: InkWell(
                            onTap: () {
                              bloc.onSubmit(bloc.phoneController.text);
                            },
                            child: Icon(Icons.search,
                                color: AppColors.getTextColor(context),
                                size: 20,
                              ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 40,
                            minHeight: 20,
                          ),
                          suffixIconWidget: enableSearch
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right: AppSizes.semiRegular),
                                  child: InkWell(
                                      onTap: () {
                                        bloc.phoneController.clear();
                                        bloc.streamEnableSearch.set(false);
                                        Utility.hideKeyboard();
                                      },
                                      child: Icon(Icons.clear,
                                          color: AppColors.getTextColor(context))),
                                )
                              : null,
                        );
                      });
                },
              ),
              Spacer(),
              StreamBuilder<bool>(
                stream: bloc.streamEnableSubmit,
                builder: (context, snapshot) {
                  final isEnabled = snapshot.data ?? false;

                  return StreamBuilder(
                      stream: bloc.streamAccountCheck,
                      builder: (context, asyncSnapshot) {
                        return CustomButton(
                          enable: isEnabled,
                          text: AppLocalizations.text(LangKey.confirm),
                          onTap: isEnabled
                              ? () => bloc.onSubmit(bloc.phoneController.text)
                              : null,
                          textColor:
                              isEnabled ? AppColors.white : AppColors.getTextColor(context),
                        );
                      });
                },
              ),
              Gaps.vGap16,
            ],
          ),
        ),
      ),
    );
  }
}
