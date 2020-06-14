import 'package:flutter/material.dart';

class Styles {
  static const horizontalPaddingDefault = 20.0;
  static const verticalPaddingDefault = 8.0;
  static const defaultPaddings = EdgeInsets.symmetric(
    vertical: verticalPaddingDefault,
    horizontal: horizontalPaddingDefault
  );

  static const textSizeLarge = 22.0;
  static const textSizeDefault = 16.0;
  static const textSizeSmall = 12.0; 

  static final Color textColorStrong = _hexToColor('000000');
  static final Color textColorDefault = _hexToColor('111111');
  static final Color textColorFaint = _hexToColor('999999');
  static final Color textColorBright = _hexToColor('FFFFFF');

  static final headerLarge = TextStyle(
    fontSize: textSizeLarge,
    color: textColorStrong,
  );

  static final textDefault = TextStyle(
    fontSize: textSizeDefault,
    color: textColorDefault,
    height: 1.2,
  );

  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}