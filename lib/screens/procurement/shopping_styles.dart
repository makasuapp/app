import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class ShoppingStyles {
  static final listCardPadding = EdgeInsets.symmetric(
      vertical: 15.0, horizontal: Styles.horizontalPaddingDefault);
  static final betweenCardPadding = EdgeInsets.fromLTRB(5, 10, 5, 0);
  static final listItemsTopPadding =
      EdgeInsets.symmetric(vertical: 5.0, horizontal: 0);

  static final listCardBorder = Colors.grey;

  static final listTitleText =
      TextStyle(fontSize: Styles.textSizeDefault, fontWeight: FontWeight.bold);
  static final listDateText = TextStyle(fontSize: Styles.textSizeDefault);
  static final listItemText = TextStyle(fontSize: Styles.textSizeDefault);
}
