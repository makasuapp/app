import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/screens/common/components/calendar_slider_styles.dart';
import 'package:kitchen/services/date_converter.dart';

class CalendarSlider extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onSelect;

  CalendarSlider(this.selectedDate, this.onSelect);

  @override
  Widget build(BuildContext context) {
    final _today = DateConverter.today();
    final dates = [
      for (var i = -7; i < 8; i += 1) _today.add(Duration(days: i))
    ];
    final selectedIdx = dates.indexWhere((d) =>
        d.millisecondsSinceEpoch == this.selectedDate.millisecondsSinceEpoch);
    final initialScrollOffset = selectedIdx > -1
        ? (selectedIdx - 1) * CalendarSliderStyles.dateWidth
        : 0;

    return Container(
        height: CalendarSliderStyles.dateHeight,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller:
                ScrollController(initialScrollOffset: initialScrollOffset),
            itemCount: dates.length,
            itemBuilder: (BuildContext context, int index) =>
                _renderDate(dates[index])));
  }

  Widget _renderDate(DateTime date) {
    return InkWell(
        child: Container(
            height: CalendarSliderStyles.dateHeight,
            width: CalendarSliderStyles.dateWidth,
            color: _backgroundColor(date),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: CalendarSliderStyles.dayOfWeekPadding,
                      child: Text(DateFormat('E').format(date),
                          style: CalendarSliderStyles.dayOfWeekText)),
                  Text(date.day.toString())
                ])),
        onTap: () => this.onSelect(date));
  }

  Color _backgroundColor(DateTime date) {
    if (date.millisecondsSinceEpoch ==
        this.selectedDate.millisecondsSinceEpoch) {
      return CalendarSliderStyles.selectedDateBackground;
    } else if (date.millisecondsSinceEpoch <
        DateConverter.today().millisecondsSinceEpoch) {
      return CalendarSliderStyles.pastDateBackground;
    } else {
      return null;
    }
  }
}
