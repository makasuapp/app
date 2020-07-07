import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class OrderStyles {
  static final Color orderOverdueColor = Colors.red;
  static final Color orderStartedColor = Colors.amber[200];
  static final Color orderDefaultColor = Colors.white;

  static final orderCardPadding = EdgeInsets.symmetric(
      vertical: 15.0, horizontal: Styles.horizontalPaddingDefault);
  static final orderItemsTopPadding =
      EdgeInsets.symmetric(vertical: 5.0, horizontal: 0);
  static final orderItemText = Styles.textDefault;
}
