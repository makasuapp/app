import 'package:flutter/material.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/screens/common/step_input_item.dart';
import '../../../models/day_ingredient.dart';
import '../morning_styles.dart';
import '../../../scoped_models/scoped_day_ingredient.dart';

class MorningItem extends StatelessWidget {
  final DayIngredient ingredient;

  MorningItem(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ingredient.hadQty != null &&
                ingredient.hadQty >= ingredient.expectedQty
            ? MorningStyles.checkedItemColor
            : null,
        width: MediaQuery.of(context).size.width,
        padding: MorningStyles.listItemPadding,
        child: StepInputItem(ScopedDayIngredient.ingredientFor(ingredient).name,
            ingredient.expectedQty, InputType.Ingredient, ingredient.unit,
            adjustedInputQty: ingredient.hadQty,
            regularTextStyle: MorningStyles.listItemText,
            originalQtyStyle: MorningStyles.expectedItemText,
            adjustedQtyStyle: MorningStyles.unexpectedItemText));
  }
}
