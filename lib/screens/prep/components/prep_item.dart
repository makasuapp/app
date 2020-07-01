import 'package:flutter/material.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';
import '../../../models/step_input.dart';
import '../../../services/unit_converter.dart';

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
        _renderContent(context)
    );
  }

  Widget _renderContent(BuildContext context) {
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
      decoration: PrepStyles.listItemBorder,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: textWidgets
      )
    );
  }

  Widget _renderInput(StepInput input) {
    //TODO: show something different for half done prep items?
    if (input.inputableType == "RecipeStep" && input.unit == null
      && input.quantity == 1) {
      return Text(input.name);
    } else {
      final qty = input.quantity * this.prep.expectedQty;
      return Text("${UnitConverter.qtyWithUnit(qty, input.unit)} ${input.name}");
    }
  }
}