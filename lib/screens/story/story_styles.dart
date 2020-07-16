import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class StoryStyles {

  static final pulldownBackground = Colors.grey.withOpacity(0.1);

  static final double progressBarVerticalPadding = 15;
  static final double indicatorHeightPageBar = 3.0;
  static final double indicatorEdgeRadius = 4.0;
  static final double indicatorSpacing = 2.0;

  static final Color currentPageBarColor = Colors.blue;
  static final Color defaultPageBarColor = Colors.grey;

  static final itemPadding = EdgeInsets.fromLTRB(
      Styles.horizontalPaddingDefault, 0, Styles.horizontalPaddingDefault, 20);

  static final headerPadding = EdgeInsets.fromLTRB(0, 15, 0, 5);
  static final paddingProgressBar = EdgeInsets.symmetric(
      vertical: progressBarVerticalPadding,
      horizontal: Styles.horizontalPaddingDefault);
  static final storyItemPadding = EdgeInsets.symmetric(
      vertical: Styles.verticalPaddingDefault,
      horizontal: Styles.horizontalPaddingDefault);
  static final storyHeader =
      TextStyle(fontSize: Styles.textSizeDefault, fontWeight: FontWeight.bold);
  static final storyText = TextStyle(
      fontSize: Styles.textSizeDefault, fontWeight: FontWeight.normal);
  static final storyHeaderLarge =
      TextStyle(fontSize: Styles.textSizeLarge, fontWeight: FontWeight.bold);
}
