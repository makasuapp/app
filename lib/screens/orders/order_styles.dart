import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class OrderStyles {
  static final Color orderOverdueColor = Colors.red;
  static final Color orderStartedColor = Colors.amber[200];
  static final Color orderDefaultColor = Colors.white;
  static final Color orderDoneColor = Colors.grey;
  static final Color newUnseenOrderColor = Colors.blue;

  static final Color currentOrdersBorder = Colors.black.withOpacity(0.8);
  static final currentOrdersPadding = EdgeInsets.symmetric(
      vertical: 10.0, horizontal: Styles.horizontalPaddingDefault);
  static final orderListBottomPadding = EdgeInsets.symmetric(
      vertical: 60.0, horizontal: Styles.horizontalPaddingDefault);

  static final orderCardPadding = EdgeInsets.symmetric(
      vertical: 15.0, horizontal: Styles.horizontalPaddingDefault);

  static final orderItemsTopPadding =
      EdgeInsets.symmetric(vertical: 5.0, horizontal: 0);
  static final orderItemsTopBorder = BoxDecoration(
      border:
          Border(bottom: BorderSide(width: 0.5, color: Styles.textColorFaint)));
  static final orderItemText = TextStyle(
    fontSize: Styles.textSizeLarge,
    color: Styles.textColorDefault,
  );
  static final doneItemText = TextStyle(
      fontSize: Styles.textSizeLarge,
      color: Styles.textColorDefault,
      decoration: TextDecoration.lineThrough);

  static final orderDetailItemPadding =
      EdgeInsets.symmetric(vertical: 12.0, horizontal: 0);
}
