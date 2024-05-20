import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    } else {
      hexColor = _moveLastTwoCharsToBeginning(hexColor);
    }
    return int.parse(hexColor, radix: 16);
  }

  static String _moveLastTwoCharsToBeginning(String input) {
    String lastTwoChars = input.substring(input.length - 2);
    String remainingChars = input.substring(0, input.length - 2);
    return lastTwoChars + remainingChars;
  }

  HexColor(final String? hexColor) : super(hexColor != null ? _getColorFromHex(hexColor) : Colors.transparent.value);
}
