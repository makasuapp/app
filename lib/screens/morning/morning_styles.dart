import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class MorningStyles {
  static const _headerTopPadding = 30.0;
  static const _headerBottomPadding = 10.0;
  static final listHeaderPadding = EdgeInsets.fromLTRB(
    Styles.horizontalPaddingDefault,
    _headerTopPadding,
    Styles.horizontalPaddingDefault,
    _headerBottomPadding
  );

  static const _headerSpacing = 1.2;
  static final listHeader = TextStyle(
    fontSize: Styles.textSizeSmall,
    fontWeight: FontWeight.bold,
    color: Styles.textColorFaint,
    letterSpacing: _headerSpacing
  );

  static const listItemVerticalPadding = 15.0;
  static final listItemPadding = EdgeInsets.symmetric(
    vertical: listItemVerticalPadding,
    horizontal: Styles.horizontalPaddingDefault
  );
  static final listItemText = TextStyle(
    fontSize: Styles.textSizeLarge,
    color: Styles.textColorDefault,
  );
  static final unexpectedItemText = TextStyle(
    fontSize: Styles.textSizeLarge,
    color: Colors.red,
  );
  static final expectedItemText = TextStyle(
    fontSize: Styles.textSizeLarge,
    color: Styles.textColorFaint,
    decoration: TextDecoration.lineThrough
  );

  static final adjustQuantityTopPadding = EdgeInsets.symmetric(
    vertical: 20.0,
    horizontal: 0
  );
  static final adjustQuantityUnitText = TextStyle(
    fontSize: 40.0,
    color: Styles.textColorDefault,
  );
}