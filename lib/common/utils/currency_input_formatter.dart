import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,##0", "vi_VN");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Parse the digits as a number
    int value = int.parse(digitsOnly);

    // Format with thousand separators
    String formattedText = _formatter.format(value);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  /// Helper method to get the numeric value from formatted text
  static int getNumericValue(String formattedText) {
    String digitsOnly = formattedText.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return 0;
    return int.parse(digitsOnly);
  }

  /// Helper method to format a number to display text
  static String formatNumber(int number) {
    final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
    return formatter.format(number);
  }
}
