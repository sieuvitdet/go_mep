import 'package:flutter/material.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/presentation/auth/change_password_first_time/bloc/change_password_first_time_bloc.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';

class ChangePasswordFirstTimeScreen extends StatefulWidget {
  const ChangePasswordFirstTimeScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordFirstTimeScreen> createState() =>
      _ChangePasswordFirstTimeScreenState();
}

class _ChangePasswordFirstTimeScreenState
    extends State<ChangePasswordFirstTimeScreen> {
  late ChangePasswordFirstTimeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChangePasswordFirstTimeBloc(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child:
                    const Icon(Icons.arrow_back_sharp, color: Colors.black87),
              ),
              Gaps.vGap8,
              CustomText(
                text: AppLocalizations.text(LangKey.create_new_password),
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              Gaps.vGap8,
              CustomText(
                text: AppLocalizations.text(
                    LangKey.enter_account_and_password_below_to_continue),
                fontSize: 15,
                color: Colors.black87,
              ),
              Gaps.vGap32,
              StreamBuilder<String?>(
                stream: _bloc.streamErrorUserName.output,
                initialData: null,
                builder: (_, snapshot) {
                  return CustomTextField(
                    controller: _bloc.userNameController,
                    hintText: AppLocalizations.text(LangKey.username),
                    isRequired: true,
                    errorMessage: snapshot.data,
                    onChanged: (value) => _bloc.validateEnableButton(),
                    backgroundColor: snapshot.data == null
                        ? AppColors.white
                        : Colors.red.withValues(alpha: 0.1),
                    borDerColor: snapshot.data == null
                        ? AppColors.borderTextField
                        : AppColors.red,
                    maxLines: 1,
                    maxLength: 15,
                  );
                },
              ),
              Gaps.vGap20,
              // Password
              StreamBuilder<String?>(
                stream: _bloc.streamErrorPassword.output,
                initialData: null,
                builder: (_, snapshot) {
                  return CustomTextField(
                    maxLines: 1,
                    maxLength: 15,
                    controller: _bloc.passwordController,
                    hintText: AppLocalizations.text(LangKey.password),
                    isRequired: true,
                    errorMessage: snapshot.data,
                    onChanged: (value) => _bloc.validateEnableButton(),
                    backgroundColor: snapshot.data == null
                        ? Colors.white
                        : Colors.red.withValues(alpha: 0.1),
                    borDerColor: snapshot.data == null
                        ? AppColors.borderTextField
                        : AppColors.red,
                    obscureText: true,
                  );
                },
              ),
              Gaps.vGap20,
              // Confirm Password
              StreamBuilder<String?>(
                stream: _bloc.streamErrorConfirmPassword.output,
                initialData: null,
                builder: (_, snapshot) {
                  return CustomTextField(
                    maxLines: 1,
                    maxLength: 15,
                    controller: _bloc.confirmPasswordController,
                    hintText: AppLocalizations.text(LangKey.reenter_password),
                    isRequired: true,
                    errorMessage: snapshot.data,
                    onChanged: (value) => _bloc.validateEnableButton(),
                    backgroundColor: snapshot.data == null
                        ? Colors.white
                        : Colors.red.withValues(alpha: 0.1),
                    borDerColor: snapshot.data == null
                        ? AppColors.borderTextField
                        : AppColors.red,
                    obscureText: true,
                  );
                },
              ),
              Gaps.vGap32,
              StreamBuilder<bool>(
                stream: _bloc.streamEnableButton.output,
                initialData: false,
                builder: (_, snapshot) {
                  bool enable = snapshot.data ?? false;
                  return CustomButton(
                    text: AppLocalizations.text(LangKey.confirm),
                    onTap: _bloc.onSubmit,
                    color: enable ? AppColors.primary : AppColors.greyLight,
                    textColor: enable ? AppColors.white : AppColors.black,
                    radius: 12,
                    expand: true,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
