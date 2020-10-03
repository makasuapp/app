import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/services/date_converter.dart';
import 'calendar_slider.dart';

class DateSelector extends StatelessWidget {
  final DateTime displayDate;
  final Function(DateTime) onSelect;

  DateSelector(this.displayDate, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        key: GlobalKey(),
        title: _renderDisplayText(),
        children: [CalendarSlider(this.displayDate, this.onSelect)]);
  }

  Widget _renderDisplayText() {
    return Text("Viewing: ${_dateText()}");
  }

  String _dateText() {
    final today = DateConverter.today();
    if (this.displayDate.millisecondsSinceEpoch ==
        today.millisecondsSinceEpoch) {
      return "Today";
    } else if (displayDate.millisecondsSinceEpoch ==
        today.add(Duration(days: 1)).millisecondsSinceEpoch) {
      return "Tomorrow";
    } else {
      return DateFormat('MMMd').format(displayDate);
    }
  }
}
