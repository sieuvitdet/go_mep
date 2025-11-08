import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? phoneNumber;
  const ResetPasswordScreen(
      {Key? key, this.phoneNumber})
      : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ResetPasswordBloc(context);
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
      body: GestureDetector(
        onTap: () {
          Utility.hideKeyboard();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Tạo mật khẩu mới",
                  fontSize: AppTextSizes.subHeader,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                Gaps.vGap16,
                RichText(
                  text: TextSpan(
                    text: "Mật khẩu",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: AppTextSizes.body,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.vGap8,
                StreamBuilder2<String?, bool?>(
                  stream1: bloc.streamErrorPasswordNew.output,
                  stream2: bloc.streamShowPasswordNew.output,
                  initialData1: null,
                  initialData2: false,
                  builder: (_, snapshot1, snapshot2) {
                    return CustomTextField(
                      maxLines: 1,
                      maxLength: 15,
                      controller: bloc.passwordNewController,
                      focusNode: bloc.passwordNewNode,
                      hintText: "Mật khẩu",
                      errorMessage: snapshot1 ?? "",
                      onChanged: (value) => bloc.validateEnableSubmit(),
                      backgroundColor: snapshot1 == null
                          ? AppColors.white
                          : AppColors.red.withValues(alpha: 0.1),
                      borDerColor: snapshot1 == null
                          ? AppColors.borderTextField
                          : AppColors.red,
                      suffixIcon:
                          snapshot2 == false ? Assets.icEye : Assets.icEyeOff,
                      suffixIconColor: AppColors.hint,
                      onSuffixIconTap: () => bloc.onShowPasswordNew(),
                      obscureText: snapshot2 == false,
                      suffixIconSize: 24,
                    );
                  },
                ),
                Gaps.vGap16,
                RichText(
                  text: TextSpan(
                    text: "Nhập lại mật khẩu",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: AppTextSizes.body,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.vGap8,
                StreamBuilder2<String?, bool?>(
                  stream1: bloc.streamErrorConfirmPasswordNew.output,
                  stream2: bloc.streamShowPasswordConfirmNew.output,
                  initialData1: null,
                  initialData2: false,
                  builder: (_, snapshot1, snapshot2) {
                    return CustomTextField(
                      maxLines: 1,
                      maxLength: 15,
                      controller: bloc.confirmPasswordNewController,
                      focusNode: bloc.confirmPasswordNewNode,
                      hintText: "Nhập lại mật khẩu",
                      errorMessage: snapshot1 ?? "",
                      onChanged: (value) => bloc.validateEnableSubmit(),
                      backgroundColor: snapshot1 == null
                          ? AppColors.white
                          : AppColors.red.withValues(alpha: 0.1),
                      borDerColor: snapshot1 == null
                          ? AppColors.borderTextField
                          : AppColors.red,
                      suffixIcon:
                          snapshot2 == false ? Assets.icEye : Assets.icEyeOff,
                      onSuffixIconTap: () => bloc.onShowPasswordConfirmNew(),
                      suffixIconColor: AppColors.hint,
                      obscureText: snapshot2 == false,
                      suffixIconSize: 24,
                    );
                  },
                ),
                Spacer(),
                StreamBuilder<bool>(
                  stream: bloc.streamEnableSubmit,
                  builder: (context, snapshot) {
                    final isEnabled = snapshot.data ?? false;

                    return CustomButton(
                      enable: isEnabled,
                      text: AppLocalizations.text(LangKey.confirm),
                      onTap: isEnabled
                          ? () => bloc.onSubmit()
                          : null,
                      textColor: isEnabled ? AppColors.white : AppColors.hint,
                    );
                  },
                ),
                Gaps.vGap16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class StreamBuilder2<A, B> extends StatelessWidget {
  final Stream<A> stream1;
  final A initialData1;
  final Stream<B> stream2;
  final B initialData2;
  final Widget Function(BuildContext, A, B) builder;

  const StreamBuilder2({
    Key? key,
    required this.stream1,
    required this.initialData1,
    required this.stream2,
    required this.initialData2,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<A>(
      stream: stream1,
      initialData: initialData1,
      builder: (context, snapshot1) {
        return StreamBuilder<B>(
          stream: stream2,
          initialData: initialData2,
          builder: (context, snapshot2) {
            return builder(context, snapshot1.data as A, snapshot2.data as B);
          },
        );
      },
    );
  }
}
