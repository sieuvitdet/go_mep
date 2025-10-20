import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

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
          FocusScope.of(context).unfocus();
          bloc.streamShowSearchResults.set(false);
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    StreamBuilder<String?>(
                      stream: bloc.streamErrorAccount,
                      builder: (context, snapshot) {
                        return CustomTextField(
                          controller: bloc.accountController,
                          focusNode: bloc.accountNode,
                          hintText:
                              AppLocalizations.text(LangKey.search_by_username),
                          errorMessage: snapshot.data,
                          onSuffixIconTap: () {
                            bloc.accountController.clear();
                            bloc.streamShowSearchResults.set(false);
                          },
                        );
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: bloc.streamShowSearchResults,
                      initialData: false,
                      builder: (context, showSnapshot) {
                        if (!showSnapshot.data!) return SizedBox.shrink();

                        return StreamBuilder<List<UserAccount>>(
                          stream: bloc.streamSearchResults,
                          initialData: [],
                          builder: (context, resultsSnapshot) {
                            final results = resultsSnapshot.data ?? [];
                            if (results.isEmpty) return SizedBox.shrink();

                            return Positioned(
                              top: 56,
                              left: 0,
                              right: 0,
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  constraints: BoxConstraints(maxHeight: 200),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: results.length,
                                    itemBuilder: (context, index) {
                                      final user = results[index];
                                      return InkWell(
                                        onTap: () => bloc.selectUser(user),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            border: index != results.length - 1
                                                ? Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.grey[200]!))
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary
                                                      .withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  color: AppColors.primary,
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user.username,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      user.fullName,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
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
                          textColor:
                              isEnabled ? AppColors.white : AppColors.hint,
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
      ),
    );
  }
}
