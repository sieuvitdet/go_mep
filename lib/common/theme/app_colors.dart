import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color error = Color(0xFFCF6679);
  static const Color black = Colors.black;
  static const Color onSecondary = Colors.black;
  static const Color onBackground = Colors.white;
  static const Color onSurface = Colors.white;
  static const Color onError = Colors.black;
  static const Color white = Colors.white;
  static const Color red = Colors.red;
  static const Color labelSecondary = Color(0xFF3C3C43);
  static const Color border = Color(0xFF3C3C42);
  static const Color hint = Color(0xFF7B7F95);
  static const Color grey = Colors.grey;
  static const Color blue = Colors.blue;
  static const Color green = Colors.green;
  static const Color primary = Color(0xFF008239);
  static const Color greyLight = Color(0xFFE4E5E9);
  static const Color greyLightBackGround = Color(0xFFF4F5F7);
  static const Color borderTextField = Color(0xFFE4E5E9);
  static const Color yellow = Color(0xFFFFC107);

  // Tire status colors
  static const Color tireCurrentGreen = Color(0xFF388E3C);
  static const Color tireReplacementOrange = Color(0xFFF57C00);
  static const Color tireEmptyGrey = Color(0xFFBDBDBD);
  static const Color tireSpareBlue = Color(0xFF1976D2);
  static const Color tireSpareEmptyGrey = Color(0xFFE0E0E0);
  static const Color tireDefaultGrey = Color(0xFF757575);

  // Selection and UI colors
  static const Color tireSelectionBlue = Color(0xFF1E88E5);
  static const Color shadowColor = Color(0x42000000); // Colors.black26
  static const Color iconWhite70 = Color(0xB3FFFFFF); // Colors.white70
  static const Color axleConnectionRed =Color(0xFFE53935); // Red connecting line

  // Login screen colors
  static const Color gradientStart = Color(0xFF5691FF);
  static const Color gradientEnd = Color(0xFFDE50D0);
  static const Color textFieldBorder = Color(0xFF000000);
  static const Color textFieldPlaceholder = Color(0xFF7B7F95);

  // Theme-based colors
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
  }

  static Color getBackgroundCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF121212)
        : AppColors.greyLightBackGround;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color.fromRGBO(0, 0, 0, 1);
  }

  static Color getTextFieldBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.background;
  }

  static Color getTextFieldBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.greyLight;
  }

  static Color getTextFieldTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : AppColors.black;
  }

  static Color getBottomNavigationBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : AppColors.white;
  }

  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.greyLight.withValues(alpha: 0.3)
        : AppColors.black.withValues(alpha: 0.1);
  }
}
