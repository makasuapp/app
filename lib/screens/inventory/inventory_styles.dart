import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class InventoryStyles {
  static const _headerTopPadding = 30.0;
  static const _headerBottomPadding = 10.0;
  static final headerPadding = EdgeInsets.fromLTRB(
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

  static const inventoryItemVerticalPadding = 15.0;
  static final inventoryItemPadding = EdgeInsets.symmetric(
    vertical: inventoryItemVerticalPadding,
    horizontal: Styles.horizontalPaddingDefault
  );
  static final inventoryItemText = TextStyle(
    fontSize: Styles.textSizeLarge,
    color: Styles.textColorDefault,
  );
}