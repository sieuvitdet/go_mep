import 'package:flutter/material.dart';
import '../theme/figma_colors.dart';

class FigmaInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const FigmaInputField({
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
  State<FigmaInputField> createState() => _FigmaInputFieldState();
}

class _FigmaInputFieldState extends State<FigmaInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: FigmaDimensions.inputWidth,
      height: FigmaDimensions.inputHeight,
      decoration: BoxDecoration(
        color: FigmaColors.inputBackground,
        borderRadius: BorderRadius.circular(FigmaDimensions.inputBorderRadius),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        style: FigmaTextStyles.inputText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: FigmaTextStyles.inputHint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: FigmaDimensions.inputPadding,
            vertical: 12,
          ),
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}

class FigmaPasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const FigmaPasswordField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  State<FigmaPasswordField> createState() => _FigmaPasswordFieldState();
}

class _FigmaPasswordFieldState extends State<FigmaPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return FigmaInputField(
      hintText: widget.hintText,
      controller: widget.controller,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      validator: widget.validator,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Container(
          width: FigmaDimensions.iconSizeMedium,
          height: FigmaDimensions.iconSizeMedium,
          padding: const EdgeInsets.all(4),
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: FigmaColors.iconSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
