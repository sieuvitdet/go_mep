import 'package:flutter_svg/svg.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:flutter/material.dart';

class GoMepLoadingDialog extends StatefulWidget {
  final String? message;

  const GoMepLoadingDialog({
    super.key,
    this.message,
  });

  static Future<void> show(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => GoMepLoadingDialog(
        message: message,
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  State<GoMepLoadingDialog> createState() => _GoMepLoadingDialogState();
}

class _GoMepLoadingDialogState extends State<GoMepLoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
              opacity: _fadeAnimation.value,
              child: Center(
                  child: Transform.scale(
                scale: _scaleAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.semiRegular),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: AppSizes.semiRegular,
                        horizontal: AppSizes.regular * 2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.white.withValues(alpha: 0.2), AppColors.white.withValues(alpha: 0.2)],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.semiRegular),
                      // border: Border.all(
                      //   color: Colors.white.withValues(alpha: 0.2),
                      //   width: 1.5,
                      // ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bot animation
                        SizedBox(
                          width: AppSizes.screenSize(context).width * 0.3,
                          child: SvgPicture.asset(
                            Assets.icFoodGradient,
                            width: 32,
                            height: 32,
                            // colorFilter: ColorFilter.mode(
                            //   AppColors.getTextFieldTextColor(context),
                            //   BlendMode.srcIn,
                            // ),
                          ),
                        ),
                        Gaps.vGap8,
                        // Loading text
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => LinearGradient(
                          colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                          child: Text(
                            widget.message ?? "Đang xử lý...",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Gaps.vGap12,
                        // Loading dots animation
                        _LoadingDots(),
                      ],
                    ),
                  ),
                ),
              )));
        },
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: 0.5 + _animations[index].value * 0.5,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
