import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_mep_application/common/utils/utility.dart';

class AdaptiveStatusBar extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const AdaptiveStatusBar({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    Utility.setStatusBarForBackground(bgColor);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _getStatusBarBrightness(bgColor),
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: _getStatusBarBrightness(bgColor),
      ),
      child: child,
    );
  }

  Brightness _getStatusBarBrightness(Color backgroundColor) {
    final double relativeLuminance = backgroundColor.computeLuminance();
    return relativeLuminance < 0.5 ? Brightness.light : Brightness.dark;
  }
}
