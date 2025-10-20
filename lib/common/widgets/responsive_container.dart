import 'package:flutter/material.dart';
import '../theme/figma_colors.dart';
import 'figma_button.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.maxHeight,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate responsive dimensions
    final containerWidth = maxWidth ?? (screenWidth > FigmaDimensions.screenWidth 
        ? FigmaDimensions.screenWidth 
        : screenWidth);
    final containerHeight = maxHeight ?? (screenHeight > FigmaDimensions.screenHeight 
        ? FigmaDimensions.screenHeight 
        : screenHeight);
    
    return Center(
      child: Container(
        width: containerWidth,
        height: containerHeight,
        padding: padding ?? const EdgeInsets.all(FigmaDimensions.spacingMedium),
        decoration: BoxDecoration(
          color: backgroundColor ?? FigmaColors.backgroundPrimary,
          borderRadius: borderRadius ?? const BorderRadius.all(
            Radius.circular(FigmaDimensions.screenBorderRadius)
          ),
        ),
        child: child,
      ),
    );
  }
}

class ResponsiveInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const ResponsiveInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final inputWidth = screenWidth > FigmaDimensions.screenWidth 
        ? FigmaDimensions.inputWidth 
        : screenWidth - (FigmaDimensions.spacingMedium * 2);
    
    return Container(
      width: inputWidth,
      height: FigmaDimensions.inputHeight,
      decoration: BoxDecoration(
        color: FigmaColors.inputBackground,
        borderRadius: BorderRadius.circular(FigmaDimensions.inputBorderRadius),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onTap: onTap,
        onChanged: onChanged,
        style: FigmaTextStyles.inputText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: FigmaTextStyles.inputHint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: FigmaDimensions.inputPadding,
            vertical: 12,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final FigmaButtonType type;
  final bool isLoading;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = FigmaButtonType.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth > FigmaDimensions.screenWidth 
        ? FigmaDimensions.buttonWidth 
        : screenWidth - (FigmaDimensions.spacingMedium * 2);
    
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: buttonWidth,
        height: FigmaDimensions.buttonHeight,
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
