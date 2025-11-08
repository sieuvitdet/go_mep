import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';

class CustomOtpTextField extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final Function(String) onChanged;
  final bool hasError;
  final bool isValid;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const CustomOtpTextField({
    Key? key,
    required this.length,
    required this.onCompleted,
    required this.onChanged,
    required this.controllers,
    required this.focusNodes,
    this.hasError = false,
    this.isValid = false,
  }) : super(key: key);

  @override
  State<CustomOtpTextField> createState() => _CustomOtpTextFieldState();
}

class _CustomOtpTextFieldState extends State<CustomOtpTextField> {
  @override
  void initState() {
    super.initState();

    // Focus on first field initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.focusNodes.isNotEmpty) {
        widget.focusNodes[0].requestFocus();
      }
    });
  }

  void _handleTextChange(String value, int index) {
    // Handle auto-focus navigation
    if (value.length == 1) {
      // Move to next field
      if (index < widget.length - 1) {
        widget.focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus
        widget.focusNodes[index].unfocus();
      }
    }

    // Check if all fields are filled and notify parent
    final otpCode = widget.controllers.map((c) => c.text).join();
    widget.onChanged(otpCode);

    if (otpCode.length == widget.length) {
      widget.onCompleted(otpCode);
    }
  }

  void _handleBackspace(int index) {
    // Handle backspace navigation
    if (widget.controllers[index].text.isEmpty && index > 0) {
      widget.focusNodes[index - 1].requestFocus();
    }
  }

  void fillOtp(String otp) {
    if (otp.length != widget.length) return;

    for (int i = 0; i < widget.length; i++) {
      widget.controllers[i].text = otp[i];
    }

    // Unfocus all fields
    for (var node in widget.focusNodes) {
      node.unfocus();
    }

    widget.onCompleted(otp);
  }

  Color _getBorderColor() {
    if (widget.hasError) return AppColors.red;
    if (widget.isValid) return AppColors.primary;
    return AppColors.greyLight;
  }

  Color _getBackgroundColor() {
    if (widget.hasError) return Color(0xFFFFF0F0);
    if (widget.isValid) return AppColors.white;
    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => Container(
          width: 48,
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: Border.all(
              color: _getBorderColor(),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: widget.controllers[index],
            focusNode: widget.focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintText: '-',
              hintStyle: TextStyle(
                color: AppColors.hint,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onTap: () {
              // Select all text when tapping on field with existing content
              if (widget.controllers[index].text.isNotEmpty) {
                widget.controllers[index].selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: widget.controllers[index].text.length,
                );
              }
            },
            onChanged: (value) {
              // Limit to single character
              if (value.length > 1) {
                // Take only the last character (newest input)
                value = value.substring(value.length - 1);
                widget.controllers[index].value = TextEditingValue(
                  text: value,
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                );
              }

              _handleTextChange(value, index);

              // Handle backspace navigation
              if (value.isEmpty) {
                _handleBackspace(index);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
