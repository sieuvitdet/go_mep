import 'package:flutter/material.dart';
import '../theme/figma_colors.dart';

class FigmaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final FigmaButtonType type;
  final bool isLoading;
  final double? width;
  final double? height;

  const FigmaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = FigmaButtonType.primary,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width ?? FigmaDimensions.buttonWidth,
        height: height ?? FigmaDimensions.buttonHeight,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(FigmaDimensions.buttonBorderRadius),
          border: type == FigmaButtonType.secondary 
              ? Border.all(color: FigmaColors.buttonBorder, width: 1)
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getTextColor(),
                    ),
                  ),
                )
              : Text(
                  text,
                  style: FigmaTextStyles.buttonPrimary.copyWith(
                    color: _getTextColor(),
                  ),
                ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case FigmaButtonType.primary:
        return FigmaColors.buttonPrimary;
      case FigmaButtonType.secondary:
        return FigmaColors.buttonSecondary.withOpacity(0.0);
      case FigmaButtonType.outline:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case FigmaButtonType.primary:
        return FigmaColors.textPrimary;
      case FigmaButtonType.secondary:
        return FigmaColors.textPrimary;
      case FigmaButtonType.outline:
        return FigmaColors.textPrimary;
    }
  }
}

enum FigmaButtonType {
  primary,
  secondary,
  outline,
}

class FigmaLinkButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextAlign textAlign;

  const FigmaLinkButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        textAlign: textAlign,
        style: FigmaTextStyles.link,
      ),
    );
  }
}
