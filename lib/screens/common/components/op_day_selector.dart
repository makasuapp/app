import 'package:flutter/material.dart';
import 'package:kitchen/scoped_models/scoped_op_day.dart';
import 'package:kitchen/scoped_models/scoped_user.dart';
import 'date_selector.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../service_locator.dart';

class OpDaySelector extends StatelessWidget {
  final scopedUser = locator<ScopedUser>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOpDay>(
        builder: (context, child, scopedOpDay) => DateSelector(
            scopedOpDay.date, (date) => _onSelectDate(date, scopedOpDay)));
  }

  void _onSelectDate(DateTime date, ScopedOpDay scopedOpDay) {
    final kitchenId = scopedUser.getKitchenId();
    scopedOpDay.loadOpDay(kitchenId, newDate: date, forceLoad: true);
  }
}
