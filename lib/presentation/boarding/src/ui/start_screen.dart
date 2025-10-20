import 'package:flutter_svg/svg.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<int> _characterCount;
  final String _welcomeText = "Chào mừng bạn đến với\n Go Mep";

  @override
  void initState() {
    super.initState();

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _characterCount = StepTween(
      begin: 0,
      end: _welcomeText.length,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A1A2E),
                  const Color(0xFF16213E),
                  const Color(0xFF0F3460),
                ],
              ),
            ),
          ),
          Positioned.fill(
              child: SizedBox(
              width: 127,
              height: 127,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                      'assets/figma/logo_map_circle.svg',
                      width: 127,
                      height: 127,
                    ),
                  // Inner gradient shape
                  SvgPicture.asset(
                      'assets/figma/logo_pin_shape.svg',
                      width: 57,
                      height: 71,
                    ),
                  // Car icon
                  SvgPicture.asset(
                      'assets/figma/logo_car_icon.svg',
                      width: 17,
                      height: 17,
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.regular, vertical: AppSizes.extraLarge),
              width: double.infinity,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedBuilder(
                    animation: _characterCount,
                    builder: (context, child) {
                      final displayText = _welcomeText.substring(0, _characterCount.value);
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              AppColors.gradientEnd,
                              AppColors.gradientStart,
                              AppColors.gradientEnd,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ).createShader(bounds);
                        },
                        child: Text(
                          displayText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: const Color(0xFFFFD700).withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                              Shadow(
                                color: const Color(0xFFFFA500).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Gaps.vGap20,
                  Utility.wrapWithBottomSafeArea(
                    context,
                    Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                              colors: [
                                AppColors.gradientStart,
                                AppColors.gradientEnd,
                              ],
                            ),
                      color:  AppColors.greyLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          CustomNavigator.pushReplacement(
                              context, LoginScreen());
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: Text(
                            AppLocalizations.text(LangKey.login),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:  Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
