import 'package:flutter/material.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';
import '../../../models/step_input.dart';
import '../../../services/unit_converter.dart';
import '../../../scoped_models/scoped_day_prep.dart';

class PrepItem extends StatelessWidget {
  final DayPrep prep;
  final void Function() onEdit;

  PrepItem(this.prep, {this.onEdit});

  @override
  Widget build(BuildContext context) {
    return _renderContent(context);
  }

  Widget _renderContent(BuildContext context) {
    var widgets = List<Widget>();
    final recipeStep = ScopedDayPrep.recipeStepFor(prep);

    widgets.add(Text(recipeStep.instruction, style: PrepStyles.listItemText));

    widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_renderIngredients(recipeStep.inputs), _renderButtons()]));

    return Container(
        padding: PrepStyles.listItemPadding,
        decoration: PrepStyles.listItemBorder,
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: widgets));
  }

  Widget _renderIngredients(List<StepInput> inputs) {
    if (inputs.length > 0) {
      var widgets = List<Widget>();
      widgets.add(Container(
          padding: PrepStyles.ingredientsHeaderPadding,
          child: Text("Ingredients", style: PrepStyles.ingredientsHeader)));

      inputs.forEach((input) => widgets.add(_renderInput(input)));

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
    } else {
      return Container(height: 0, width: 0);
    }
  }

  Widget _renderInput(StepInput input) {
    //TODO: show something different for half done prep items?
    if (input.inputableType == "RecipeStep" &&
        input.unit == null &&
        input.quantity == 1) {
      return Text(input.name);
    } else {
      final qty = input.quantity * this.prep.expectedQty;
      return Text(
          "${UnitConverter.qtyWithUnit(qty, input.unit)} ${input.name}");
    }
  }

  Widget _renderButtons() {
    final editButton = this.onEdit != null
        ? IconButton(icon: Icon(Icons.edit), onPressed: () => this.onEdit())
        : Container(width: 0, height: 0);

    return Row(
        mainAxisAlignment: MainAxisAlignment.end, children: [editButton]);
  }
}
