import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_input.dart';
import '../../../models/day_input.dart';
import '../morning_styles.dart';
import './morning_item.dart';

//TODO(po_time): if ingredient was from yesterday, today should have that prep instead
class MorningList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayInput>(
        builder: (context, child, scopedDayInput) => SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _renderView(context, scopedDayInput))));
  }

  List<Widget> _renderView(
      BuildContext context, ScopedDayInput scopedDayInput) {
    var uncheckedInputs = List<DayInput>();
    var missingInputs = List<DayInput>();
    var checkedInputs = List<DayInput>();

    scopedDayInput.inputs.forEach((input) => {
          if (input.hadQty == null)
            {uncheckedInputs.add(input)}
          else if (input.expectedQty > input.hadQty)
            {missingInputs.add(input)}
          else
            {checkedInputs.add(input)}
        });

    var viewItems = List<Widget>();
    viewItems.add(_headerText("Unchecked Ingredients"));
    viewItems.addAll(uncheckedInputs.map((i) => MorningItem(i)).toList());

    if (missingInputs.length > 0) {
      viewItems.add(_headerText("Missing Ingredients"));
      viewItems.addAll(missingInputs.map((i) => MorningItem(i)).toList());
    }

    if (checkedInputs.length > 0) {
      viewItems.add(_headerText("Checked Ingredients"));
      viewItems.addAll(checkedInputs.map((i) => MorningItem(i)).toList());
    }

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }

  Widget _headerText(String text) {
    return Container(
        padding: MorningStyles.listHeaderPadding,
        child: Text(text.toUpperCase(), style: MorningStyles.listHeader));
  }
}
