import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class OrderStoryStyles {
  static final instructionsPadding =
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0);
  static final instructionsText = TextStyle(
    fontSize: Styles.textSizeLarge,
    color: Styles.textColorDefault,
  );
  static final ingredientText = TextStyle(
    fontSize: Styles.textSizeSmall,
  );

  static final ingredientsHeaderPadding = EdgeInsets.fromLTRB(0, 10.0, 0, 5);
  static final ingredientsHeader = TextStyle(
    fontSize: Styles.textSizeSmall,
    color: Styles.textColorFaint,
  );
}
