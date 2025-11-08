import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/extension.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs_key.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/auth/login/bloc/login_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoginBloc(context);
    Globals.prefs.setString(SharedPrefsKey.token, "");
    Globals.alreadyShowPopupExpired = false;
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          children: [
            Gaps.vGap100,
            _buildLogo(),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ).createShader(bounds),
              child: const Text(
                'GoMep',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
             SizedBox(height: 30),
            // Phone number field
            StreamBuilder(
              stream: _bloc.streamErrorUserName.output,
              initialData: null,
              builder: (_, snapshot) {
                return CustomTextField(
                  maxLines: 1,
                  controller: _bloc.userNameController,
                  hintText: AppLocalizations.text(LangKey.username),
                  errorMessage: snapshot.data,
                  onChanged: (value) => _bloc.validateEnableLogin(),
                  backgroundColor: snapshot.data == null
                      ? AppColors.getTextFieldBackground(context)
                      : AppColors.red.withValues(alpha: 0.1),
                  borDerColor: snapshot.data == null
                      ? AppColors.greyLight
                      : AppColors.red,
                  textInputColor: AppColors.getTextFieldTextColor(context),
                  fontSizeHint: 16,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                );
              },
            ),
            Gaps.vGap12,
            // Password field
            StreamBuilder2<String?, bool>(
              stream1: _bloc.streamErrorPassword.output,
              initialData1: null,
              stream2: _bloc.streamShowPassword.output,
              initialData2: false,
              builder: (_, snapshot1, snapshot2) {
                return CustomTextField(
                  maxLines: 1,
                  controller: _bloc.passwordController,
                  hintText: AppLocalizations.text(LangKey.password),
                  errorMessage: snapshot1,
                  onChanged: (value) => _bloc.validateEnableLogin(),
                  backgroundColor: snapshot1 == null
                      ? AppColors.getTextFieldBackground(context)
                      : AppColors.red.withValues(alpha: 0.1),
                  borDerColor: snapshot1 == null
                      ? AppColors.greyLight
                      : AppColors.red,
                  suffixIcon: snapshot2 == false ? Assets.icEyeOff : Assets.icEye,
                  suffixIconColor: AppColors.hint,
                  onSuffixIconTap: () => _bloc.onShowPassword(),
                  obscureText: snapshot2 == false,
                  suffixIconSize: 24,
                  textInputColor: AppColors.getTextFieldTextColor(context),
                  fontSizeHint: 16,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                );
              },
            ),
            Gaps.vGap12,
            // Forgot password
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: _bloc.onForgotPassword,
                child: Text(
                  AppLocalizations.text(LangKey.forgot_password),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.getTextColor(context),
                    fontFamily: 'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Gaps.vGap46,
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
              stream: _bloc.streamEnableLogin.output,
              initialData: false,
              builder: (_, snapshot) {
                bool enable = snapshot.data ?? false;
                return Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: enable
                        ? const LinearGradient(
                            colors: [
                              AppColors.gradientStart,
                              AppColors.gradientEnd,
                            ],
                          )
                        : null,
                    color: enable ? null : AppColors.greyLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _bloc.onLogin,
                      borderRadius: BorderRadius.circular(8),
                      child: Center(
                        child: Text(
                          AppLocalizations.text(LangKey.login),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: enable ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Gaps.vGap8,
            Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: Text(
                        'Bỏ qua',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextColor(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Gaps.vGap20,  
          // Register text
            GestureDetector(
              onTap: () => _bloc.onRegister(),
              child: RichText(
                text: TextSpan(
                  text: 'Bạn chưa có tài khoản? ',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.getTextColor(context),
                    fontFamily: 'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Đăng ký',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 127,
      height: 127,
      child: Stack(
        children: [
          // Outer circle map
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/figma/logo_map_circle.svg',
              width: 127,
              height: 127,
            ),
          ),
          // Inner gradient shape
          Positioned(
            left: 35,
            top: 13,
            child: SvgPicture.asset(
              'assets/figma/logo_pin_shape.svg',
              width: 57,
              height: 71,
            ),
          ),
          // Car icon
          Positioned(
            left: 55,
            top: 84,
            child: SvgPicture.asset(
              'assets/figma/logo_car_icon.svg',
              width: 17,
              height: 17,
            ),
          ),
        ],
      ),
    );
  }
}

// StreamBuilder2 hỗ trợ lắng nghe 2 stream cùng lúc
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
