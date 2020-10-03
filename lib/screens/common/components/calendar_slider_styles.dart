import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';

class CalendarSliderStyles {
  static final Color selectedDateBackground = Colors.blue;
  static final Color pastDateBackground = Colors.grey[300];
  static const dateHeight = 60.0;
  static const dateWidth = 70.0;

  static final dayOfWeekPadding = EdgeInsets.fromLTRB(0, 5.0, 0, 10.0);
  static final dayOfWeekText = TextStyle(fontSize: Styles.textSizeDefault);
}
