import 'dart:ui';

class HexColor extends Color {
  static int getColorFromHex(String? hexColor) {
    if ((hexColor ?? "") == "") {
      hexColor = "000000";
    }
    hexColor = hexColor!.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String? hexColor) : super(getColorFromHex(hexColor));

  static Color convertHexToColor(String hexColor) {
    if (hexColor.length == 7) {
      hexColor = "#FF" + hexColor.substring(1);
    }
    int colorValue = int.parse(hexColor.substring(1), radix: 16);
    return Color(colorValue);
  }
}
