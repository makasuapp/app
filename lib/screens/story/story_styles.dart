import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class StoryStyles {
  static final itemPadding = EdgeInsets.fromLTRB(
      Styles.horizontalPaddingDefault, 0, Styles.horizontalPaddingDefault, 20);

  static final headerPadding = EdgeInsets.fromLTRB(0, 15, 0, 5);
  static final storyHeader =
      TextStyle(fontSize: Styles.textSizeDefault, fontWeight: FontWeight.bold);
  static final storyText = TextStyle(
      fontSize: Styles.textSizeDefault, fontWeight: FontWeight.normal);
}
