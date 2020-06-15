import 'package:flutter/material.dart';

class Styles {
  static const horizontalPaddingDefault = 20.0;
  static const verticalPaddingDefault = 8.0;
  static const defaultPaddings = EdgeInsets.symmetric(
    vertical: verticalPaddingDefault,
    horizontal: horizontalPaddingDefault
  );

  static const spacerVerticalPadding = 15.0;
  static const spacerPadding = EdgeInsets.symmetric(
    vertical: spacerVerticalPadding,
    horizontal: 0.0
  );

  static const textSizeLarge = 22.0;
  static const textSizeDefault = 16.0;
  static const textSizeSmall = 12.0; 

  static final Color textColorStrong = hexToColor('000000');
  static final Color textColorDefault = hexToColor('111111');
  static final Color textColorFaint = hexToColor('999999');
  static final Color textColorBright = hexToColor('FFFFFF');

  static final headerLarge = TextStyle(
    fontSize: textSizeLarge,
    color: textColorStrong,
  );

  static final textDefault = TextStyle(
    fontSize: textSizeDefault,
    color: textColorDefault,
    height: 1.2,
  );

  static final textBrightDefault = TextStyle(
    fontSize: textSizeDefault,
    color: textColorBright,
    height: 1.2,
  );

  static final textHyperlink = TextStyle(
    fontSize: textSizeDefault,
    color: Colors.lightBlue
  );

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}