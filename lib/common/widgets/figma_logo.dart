import 'package:flutter/material.dart';
import '../theme/figma_colors.dart';

class FigmaLogo extends StatelessWidget {
  final double? size;
  final Color? color;

  const FigmaLogo({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? FigmaDimensions.logoIconSize;
    final logoColor = color ?? FigmaColors.iconPrimary;

    return Column(
      children: [
        // Car icon with background
        Container(
          width: logoSize,
          height: logoSize * 1.5,
          child: Stack(
            children: [
              // Background circle
              Positioned(
                left: logoSize * 0.42,
                top: 0,
                child: Container(
                  width: logoSize * 0.16,
                  height: logoSize * 0.16,
                  decoration: BoxDecoration(
                    color: logoColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Car vector
              Positioned(
                left: logoSize * 0.36,
                top: logoSize * 0.13,
                child: Container(
                  width: logoSize * 0.28,
                  height: logoSize * 0.28,
                  child: Icon(
                    Icons.directions_car,
                    color: logoColor,
                    size: logoSize * 0.28,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: FigmaDimensions.spacingLarge),
        // GoMep text
        Text(
          'GoMep',
          style: FigmaTextStyles.logo.copyWith(
            color: logoColor,
          ),
        ),
      ],
    );
  }
}

class FigmaStatusBar extends StatelessWidget {
  final String time;
  final Color? backgroundColor;
  final Color? textColor;

  const FigmaStatusBar({
    super.key,
    this.time = '09:41',
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: FigmaDimensions.screenWidth,
      height: FigmaDimensions.statusBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: FigmaDimensions.spacingMedium),
      color: backgroundColor ?? FigmaColors.statusBarBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            time,
            style: FigmaTextStyles.statusBar.copyWith(
              color: textColor ?? FigmaColors.statusBarText,
            ),
          ),
          
          // Status indicators
          Row(
            children: [
              // Battery indicator
              _buildBatteryIndicator(),
              const SizedBox(width: FigmaDimensions.spacingSmall),
              // WiFi icon
              _buildWifiIcon(),
              const SizedBox(width: FigmaDimensions.spacingSmall),
              // Cellular icon
              _buildCellularIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryIndicator() {
    return Container(
      width: 24.09,
      height: 12.33,
      decoration: BoxDecoration(
        color: textColor ?? FigmaColors.statusBarText,
        borderRadius: BorderRadius.circular(2.67),
      ),
      child: Stack(
        children: [
          Container(
            width: 19.71,
            height: 7.98,
            margin: const EdgeInsets.only(left: 1.5, top: 2.2),
            decoration: BoxDecoration(
              color: textColor ?? FigmaColors.statusBarText,
              borderRadius: BorderRadius.circular(1.33),
            ),
          ),
          Positioned(
            right: 0,
            top: 4,
            child: Container(
              width: 1.45,
              height: 4.35,
              decoration: BoxDecoration(
                color: textColor ?? FigmaColors.statusBarText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWifiIcon() {
    return Container(
      width: 16.72,
      height: 11.93,
      decoration: BoxDecoration(
        color: textColor ?? FigmaColors.statusBarText,
      ),
    );
  }

  Widget _buildCellularIcon() {
    return Container(
      width: 18.62,
      height: 11.61,
      decoration: BoxDecoration(
        color: textColor ?? FigmaColors.statusBarText,
      ),
    );
  }
}
