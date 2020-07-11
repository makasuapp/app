import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class PrepStyles {
  static const _headerTopPadding = 30.0;
  static const _headerBottomPadding = 10.0;
  static final listHeaderPadding = EdgeInsets.fromLTRB(
      Styles.horizontalPaddingDefault,
      _headerTopPadding,
      Styles.horizontalPaddingDefault,
      _headerBottomPadding);

  static const _headerSpacing = 1.2;
  static final listHeader = TextStyle(
      fontSize: Styles.textSizeSmall,
      fontWeight: FontWeight.bold,
      color: Styles.textColorFaint,
      letterSpacing: _headerSpacing);

  static const listItemVerticalPadding = 15.0;
  static final listItemPadding = EdgeInsets.symmetric(
      vertical: listItemVerticalPadding,
      horizontal: Styles.horizontalPaddingDefault);
  static final listItemText = TextStyle(
    fontSize: Styles.textSizeLarge,
    color: Styles.textColorDefault,
  );

  static final adjustQuantityTopPadding =
      EdgeInsets.symmetric(vertical: 20.0, horizontal: 0);

  static final listItemBorder = BoxDecoration(
      border:
          Border(top: BorderSide(width: 0.5, color: Styles.textColorFaint)));

  static final ingredientsHeaderPadding = EdgeInsets.fromLTRB(0, 10.0, 0, 0);
  static final ingredientsHeader = TextStyle(
    fontSize: Styles.textSizeSmall,
    color: Styles.textColorFaint,
  );
}
