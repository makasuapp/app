import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_ingredient.dart';
import '../../common/swipable.dart';
import '../../../models/day_ingredient.dart';
import '../adjust_quantity.dart';
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
          else if (ingredient.expectedQty != ingredient.hadQty)
            {missingIngredients.add(ingredient)}
          else
            {checkedIngredients.add(ingredient)}
        });

    var viewItems = List<Widget>();
    viewItems.add(_headerText("Unchecked Ingredients"));
    viewItems.addAll(uncheckedIngredients
        .map((i) => _renderListItem(context, i, scopedIngredient))
        .toList());

    if (missingIngredients.length > 0) {
      viewItems.add(_headerText("Missing Ingredients"));
      viewItems.addAll(missingIngredients
          .map((i) => _renderListItem(context, i, scopedIngredient))
          .toList());
    }

    if (checkedIngredients.length > 0) {
      viewItems.add(_headerText("Checked Ingredients"));
      viewItems.addAll(checkedIngredients
          .map((i) => _renderListItem(context, i, scopedIngredient))
          .toList());
    }

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }

  Widget _headerText(String text) {
    return Container(
        padding: MorningStyles.listHeaderPadding,
        child: Text(text.toUpperCase(), style: MorningStyles.listHeader));
  }

  Widget _renderListItem(BuildContext context, DayIngredient ingredient,
      ScopedDayIngredient scopedIngredient) {
    final originalQty = ingredient.hadQty;

    return Swipable(
        canSwipeLeft: () => Future.value(ingredient.hadQty != null),
        canSwipeRight: () => Future.value(ingredient.hadQty == null ||
            ingredient.hadQty < ingredient.expectedQty),
        onSwipeLeft: (context) {
          scopedIngredient.updateIngredientQty(ingredient, null);
          _notifyQtyUpdate("Ingredient unchecked", context, ingredient,
              scopedIngredient, originalQty);
        },
        onSwipeRight: (context) {
          scopedIngredient.updateIngredientQty(
              ingredient, ingredient.expectedQty);
          _notifyQtyUpdate("Ingredient checked", context, ingredient,
              scopedIngredient, originalQty);
        },
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return IngredientAdjustQtyPage(ingredient,
                    onSubmit: (double setQty, BuildContext qtyViewContext) {
                  final originalQty = ingredient.hadQty;
                  scopedIngredient.updateIngredientQty(ingredient, setQty);
                  Navigator.pop(qtyViewContext);
                  _notifyQtyUpdate("Ingredient updated", context, ingredient,
                      scopedIngredient, originalQty);
                });
              }));
            },
            child: MorningItem(ingredient)));
  }

  void _notifyQtyUpdate(
      String notificationText,
      BuildContext context,
      DayIngredient ingredient,
      ScopedDayIngredient scopedIngredient,
      double originalQty) {
    Flushbar flush;
    flush = Flushbar(
        message: notificationText,
        duration: Duration(seconds: 3),
        isDismissible: true,
        mainButton: InkWell(
            onTap: () {
              scopedIngredient.updateIngredientQty(ingredient, originalQty);
              flush.dismiss();
            },
            child: Text("Undo", style: Styles.textHyperlink)))
      ..show(context);
  }
}
