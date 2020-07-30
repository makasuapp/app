import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class AdjustQuantityStyles {
  static final title =
      TextStyle(fontSize: Styles.textSizeLarge, fontWeight: FontWeight.bold);
  static final qtyPickerText = TextStyle(fontSize: Styles.textSizeLarge);
  static final unitPickerText =
      TextStyle(fontSize: Styles.textSizeLarge, color: Colors.deepPurple);

  static final double unitPickerIconSize = 24;
  static final double unitPickerUnderlineHeight = 3;
  static final Color unitPickerUnderlineColor = Colors.deepPurpleAccent;

  static final Icon unitPickerIcon = Icon(Icons.arrow_downward);
}
