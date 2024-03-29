import 'package:flutter/material.dart';

class Styles {
  static const horizontalPaddingDefault = 20.0;
  static const verticalPaddingDefault = 8.0;
  static const defaultPaddings = EdgeInsets.symmetric(
      vertical: verticalPaddingDefault, horizontal: horizontalPaddingDefault);

  static const spacerVerticalPadding = 15.0;
  static const spacerPadding =
      EdgeInsets.symmetric(vertical: spacerVerticalPadding, horizontal: 0.0);

  static const textSizeLarge = 22.0;
  static const textSizeDefault = 16.0;
  static const textSizeSmall = 12.0;

  static final Color textColorStrong = hexToColor('000000');
  static final Color textColorDefault = hexToColor('111111');
  static final Color textColorFaint = hexToColor('999999');
  static final Color textColorBright = hexToColor('FFFFFF');
  static final Color textColorHighlight = Colors.blue;

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

  static final textHyperlink =
      TextStyle(fontSize: textSizeDefault, color: Colors.lightBlue);

  static final textDefaultHighlighted = TextStyle(
    fontSize: textSizeDefault,
    color: textColorHighlight,
    height: 1.2,
  );

  static final TextStyle regularTextStyle = TextStyle(
    fontSize: textSizeDefault,
    color: textColorDefault,
  );
  static final TextStyle originalQtyStyle = TextStyle(
      fontSize: textSizeDefault,
      color: textColorFaint,
      decoration: TextDecoration.lineThrough);
  static final TextStyle adjustedQtyStyle = TextStyle(
    fontSize: textSizeDefault,
    color: Colors.red,
  );

  static final cancelBtnColor = Colors.grey;
  static final submitBtnColor = Colors.blue;
  static final submitBtnTextColor = Colors.white;
  static const defaultBtnPadding =
      EdgeInsets.symmetric(vertical: 10, horizontal: 20);
  static final defaultBtnText = TextStyle(fontSize: textSizeDefault);
  static final cancelBtnText = textBrightDefault;

  static final Color swipeRightColor = Colors.green;
  static final Color swipeLeftColor = Colors.red;

  static final Color doneBackgroundColor = Colors.grey[300];

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}
