import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/screens/common/components/step_input_item.dart';
import '../../../models/day_prep.dart';
import '../prep_styles.dart';

class PrepItem extends StatelessWidget {
  final DayPrep prep;
  final void Function() onEdit;

  PrepItem(this.prep, {this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedLookup>(
        builder: (context, child, scopedLookup) =>
            _renderContent(context, scopedLookup));
  }

  Widget _renderContent(BuildContext context, ScopedLookup scopedLookup) {
    var widgets = List<Widget>();
    final recipeStep = scopedLookup.recipeStepsMap[prep.recipeStepId];
    final recipe = scopedLookup.recipesMap[recipeStep.recipeId];

    widgets.add(Text(recipeStep.instruction, style: PrepStyles.listItemText));
    widgets.add(Container(
        padding: PrepStyles.ingredientsHeaderPadding,
        child:
            Text("Recipe: ${recipe.name}", style: PrepStyles.ingredientText)));

    widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _renderIngredients(recipeStep.inputs)),
          _renderButtons()
        ]));

    final isDone =
        this.prep.madeQty != null && this.prep.madeQty >= this.prep.expectedQty;
    return Container(
        padding: PrepStyles.listItemPadding,
        decoration: isDone ? null : PrepStyles.listItemBorder,
        color: isDone ? PrepStyles.doneItemColor : null,
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

      inputs.forEach((input) {
        final originalQty = this.prep.expectedQty * input.quantity;
        double remainingQty;
        if (this.prep.madeQty != null &&
            this.prep.madeQty < this.prep.expectedQty) {
          final toMakeConversion = (this.prep.expectedQty - this.prep.madeQty) /
              this.prep.expectedQty;
          remainingQty = originalQty * toMakeConversion;
        }

        widgets.add(StepInputItem(
            input.name, originalQty, input.inputableType, input.unit,
            adjustedInputQty: remainingQty,
            regularTextStyle: PrepStyles.ingredientText,
            adjustedQtyStyle: PrepStyles.remainingIngredientText,
            originalQtyStyle: PrepStyles.totalIngredientText));
      });

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
    } else {
      return Container(height: 0, width: 0);
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
