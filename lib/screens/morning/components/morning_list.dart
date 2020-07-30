import 'package:flutter/material.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_ingredient.dart';
import '../../../models/day_ingredient.dart';
import '../morning_styles.dart';
import './morning_item.dart';

class MorningList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayIngredient>(
        builder: (context, child, scopedDayIngredient) => SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _renderView(context, scopedDayIngredient))));
  }

  List<Widget> _renderView(
      BuildContext context, ScopedDayIngredient scopedIngredient) {
    var uncheckedIngredients = List<DayIngredient>();
    var missingIngredients = List<DayIngredient>();
    var checkedIngredients = List<DayIngredient>();

    scopedIngredient.ingredients.forEach((ingredient) => {
          if (ingredient.hadQty == null)
            {uncheckedIngredients.add(ingredient)}
          else if (ingredient.expectedQty > ingredient.hadQty)
            {missingIngredients.add(ingredient)}
          else
            {checkedIngredients.add(ingredient)}
        });

    var viewItems = List<Widget>();
    viewItems.add(_headerText("Unchecked Ingredients"));
    viewItems.addAll(uncheckedIngredients.map((i) => MorningItem(i)).toList());

    if (missingIngredients.length > 0) {
      viewItems.add(_headerText("Missing Ingredients"));
      viewItems.addAll(missingIngredients.map((i) => MorningItem(i)).toList());
    }

    if (checkedIngredients.length > 0) {
      viewItems.add(_headerText("Checked Ingredients"));
      viewItems.addAll(checkedIngredients.map((i) => MorningItem(i)).toList());
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
