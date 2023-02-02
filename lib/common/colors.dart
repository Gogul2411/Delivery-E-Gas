import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF2d297c);
const kBackground = Color.fromARGB(255, 247, 247, 247);
const decorationColor = Color(0x00effbf9);
const kPrimaryLightColor = Color(0xFFb1b1b1);
const apiLink = "https://e-gas.in/api/";
const double defaultPadding = 15.0;

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
