import 'package:flutter/material.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';
import '../../../models/step_input.dart';

class PrepItem extends StatelessWidget {
  final DayPrep prep;

  PrepItem(this.prep);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO: open detailed view
      },
      child:
        _renderContent()
    );
  }

  //TODO: render everything wrapped but as their own line
  Widget _renderContent() {
    List<Widget> textWidgets = List();

    textWidgets.add(Text(prep.recipeStep.instruction, style: PrepStyles.listItemText));

    if (prep.recipeStep.inputs.length > 0) {
      textWidgets.add(Container(
        padding: PrepStyles.ingredientsHeaderPadding,
        child: Text("Ingredients", style: PrepStyles.ingredientsHeader)
      ));

      prep.recipeStep.inputs.forEach((input) => 
        textWidgets.add(_renderInput(input)));
    }

    return Container(
      padding: PrepStyles.listItemPadding,
      child: Wrap(
        children: textWidgets
      )
    );
  }

  //TODO: add quantity, unless it's recipe step and input is quantity 1 unit null
  //multiply quantity of input by day prep
  Widget _renderInput(StepInput input) {
    return Text(input.name);
  }
}