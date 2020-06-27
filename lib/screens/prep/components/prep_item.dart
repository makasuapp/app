import 'package:flutter/material.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';

class PrepItem extends StatelessWidget {
  final DayPrep prep;

  PrepItem(this.prep);

  @override
  Widget build(BuildContext context) {
    List<Widget> textWidgets = List();

    //TODO: show the instructions, inputs (quantity adjusted for day prep), tools 
    //TODO: if step has time constraint, should show here too
    textWidgets.add(Text(prep.recipeStep.instruction));

    return Container(
      padding: PrepStyles.listItemPadding,
      child: Wrap(
        children: textWidgets
      )
    );
  }
}