import 'package:flutter/material.dart';

class FigmaColors {
  // Primary Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF606060);
  static const Color textHint = Color(0xFF606060);
  
  // Background Colors
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFFFFFFFF);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  
  // Button Colors
  static const Color buttonPrimary = Color(0xFFFFFFFF);
  static const Color buttonSecondary = Color(0xFF5691FF);
  static const Color buttonBorder = Color(0xFFFFFFFF);
  
  // Input Colors
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFFFFFFF);
  static const Color inputText = Color(0xFF000000);
  static const Color inputHint = Color(0xFF606060);
  
  // Status Bar Colors
  static const Color statusBarBackground = Color(0xFF000000);
  static const Color statusBarText = Color(0xFFFFFFFF);
  
  // Accent Colors
  static const Color accentPink = Color(0xFFDE50D0);
  static const Color accentBlue = Color(0xFF5691FF);
  
  // Icon Colors
  static const Color iconPrimary = Color(0xFFFFFFFF);
  static const Color iconSecondary = Color(0xFF606060);
  
  // Border Colors
  static const Color borderPrimary = Color(0xFFFFFFFF);
  static const Color borderSecondary = Color(0xFF606060);
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
}

class FigmaTextStyles {
  // Logo Text Style
  static const TextStyle logo = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.21,
    letterSpacing: 0,
    color: FigmaColors.textPrimary,
  );
  
  // Status Bar Text Style
  static const TextStyle statusBar = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.17,
    letterSpacing: -0.28,
    color: FigmaColors.statusBarText,
  );
  
  // Input Text Style
  static const TextStyle inputText = TextStyle(
    fontFamily: 'Roboto Condensed',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.17,
    letterSpacing: 0,
    color: FigmaColors.inputText,
  );
  
  // Input Hint Text Style
  static const TextStyle inputHint = TextStyle(
    fontFamily: 'Roboto Condensed',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.17,
    letterSpacing: 0,
    color: FigmaColors.inputHint,
  );
  
  // Button Text Style
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.17,
    letterSpacing: 0,
    color: FigmaColors.textPrimary,
  );
  
  // Link Text Style
  static const TextStyle link = TextStyle(
    fontFamily: 'Roboto Condensed',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.17,
    letterSpacing: 0,
    color: FigmaColors.textPrimary,
  );
  
  // Register Link Text Style
  static const TextStyle registerLink = TextStyle(
    fontFamily: 'Roboto Condensed',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.17,
    letterSpacing: 0,
    color: FigmaColors.textPrimary,
  );
}

class FigmaDimensions {
  // Screen Dimensions
  static const double screenWidth = 428.0;
  static const double screenHeight = 926.0;
  static const double screenBorderRadius = 32.0;
  
  // Status Bar
  static const double statusBarHeight = 44.0;
  
  // Input Fields
  static const double inputHeight = 48.0;
  static const double inputWidth = 396.0;
  static const double inputBorderRadius = 4.0;
  static const double inputPadding = 16.0;
  
  // Buttons
  static const double buttonHeight = 48.0;
  static const double buttonWidth = 396.0;
  static const double buttonBorderRadius = 8.0;
  
  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 20.0;
  static const double spacingXLarge = 40.0;
  
  // Logo
  static const double logoIconSize = 85.0;
  static const double logoTextSize = 32.0;
  
  // Icons
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}
