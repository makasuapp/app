import 'package:flutter/material.dart';
import '../../../models/day_ingredient.dart';
import '../../../services/unit_converter.dart';
import '../morning_styles.dart';

class MorningItem extends StatelessWidget {
  final DayIngredient ingredient;

  MorningItem(this.ingredient);

  @override
  Widget build(BuildContext context) {
    final expectedText =
        UnitConverter.qtyWithUnit(ingredient.expectedQty, ingredient.unit);
    List<Widget> textWidgets = List();

    if (ingredient.hadQty != null &&
        ingredient.hadQty != ingredient.expectedQty) {
      final hadText =
          UnitConverter.qtyWithUnit(ingredient.hadQty, ingredient.unit);
      textWidgets
          .add(Text("$hadText ", style: MorningStyles.unexpectedItemText));
      textWidgets
          .add(Text(expectedText, style: MorningStyles.expectedItemText));
    } else {
      textWidgets.add(Text(expectedText, style: MorningStyles.listItemText));
    }
    textWidgets
        .add(Text(" ${ingredient.name}", style: MorningStyles.listItemText));

    return Container(
        padding: MorningStyles.listItemPadding,
        child: Wrap(children: textWidgets));
  }
}
