import 'package:flutter/material.dart';

const bgcolor = Color(0xFFE5F6FC);
const topiccolor = Color(0xFF335FAA);
const btcolor = Color(0xFFF7B633);
const iconAppColor = Color(0xFFF7B633);
const btcolordelete = Color(0xFFD22B2B);

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    try {
      return int.parse(hexColor, radix: 16);
    } catch (e) {
      return 0xFFFFFFFF; // Default color value in case of error
    }
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();

    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');

    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
