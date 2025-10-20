import 'package:flutter/material.dart';

class AppSizes {
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double semiRegular = 12.0;
  static const double regular = 16.0;
  static const double semiMedium = 20.0;
  static const double medium = 24.0;
  static const double large = 32.0;
  static const double extraLarge = 40.0;
  static const double full = 100.0;
  static const double onTap = 48.0;
  static const double icon = 24;
  static const double line = 0.5;
  static const double bottomBarHeight = kBottomNavigationBarHeight;
  static const double headerBarHeight = kToolbarHeight;
  static const double paddingBottomBar = kBottomNavigationBarHeight + 40;
  static const double sizeDesktop = 1100;
  static const double sizeTablet = 650;
  static late EdgeInsets screenPadding;
  static double maxWidth = 0.0;
  static double maxHeight = 0.0;
  static double statusBarHeight = 30.0;

  static init(BuildContext context) {
    screenPadding = MediaQuery.of(context).padding;
    maxWidth = MediaQuery.sizeOf(context).width;
    maxHeight = MediaQuery.sizeOf(context).height;
    statusBarHeight = MediaQuery.paddingOf(context).top;
  }

  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);

  // Tire positioning constants
  static const double tireMarginFromEdge =
      regular; // 16px margin from container edges
  static const double tireDualOffset = 15.0; // Spacing between dual tires
  static const double tireRowSpacing =
      80.0; // Spacing between tire rows (axles)
  static const double tireSteeringTopPosition =
      120.0; // Top position for steering tires
  static const double tireDriveBaseTopPosition =
      420.0; // Base top position for drive tires
  static const double tireSpareTopPosition =
      300.0; // Top position for spare tire
  static const double tireSpareLeftOffset =
      60.0; // Left offset for spare tire positioning
  static const double borderRadiusSmall =
      3.0; // Small border radius for tire widgets
  static const double borderWidth = 2.0; // Border width for selected tires
  static const double shadowBlurRadius = 2.0; // Blur radius for tire shadows
  static const double shadowOffset = 1.0; // Shadow offset
  static const double axleConnectionLineWidth =
      5.0; // Width of axle connection line
}

class AppTextSizes {
  static double tiny = 10.0;
  static double subBody = 12.0;
  static double body = 14.0;
  static double subTitle = 16.0;
  static double title = 18.0;
  static double subHeader = 22.0;
  static double header = 24.0;
}
