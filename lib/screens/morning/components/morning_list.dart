import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_day_ingredient.dart';
import '../../../models/day_ingredient.dart';
import '../adjust_quantity.dart';
import '../morning_styles.dart';
import '../../../services/unit_converter.dart';

class MorningList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedDayIngredient>(
        builder: (context, child, scopedDayIngredient) => SingleChildScrollView(
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
    return Dismissible(
        background: Container(color: Styles.swipeRightColor),
        secondaryBackground: Container(color: Styles.swipeLeftColor),
        confirmDismiss: (direction) => _canDismissItem(direction, ingredient),
        key: UniqueKey(),
        onDismissed: (direction) =>
            _onItemDismissed(direction, context, ingredient, scopedIngredient),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AdjustQuantityPage(ingredient,
                              (double setQty, BuildContext qtyViewContext) {
                            final originalQty = ingredient.hadQty;
                            scopedIngredient.updateIngredientQty(
                                ingredient, setQty);
                            Navigator.pop(qtyViewContext);
                            _notifyQtyUpdate("Ingredient updated", context,
                                ingredient, scopedIngredient, originalQty);
                          })));
            },
            child: _renderItemText(ingredient)));
  }

  Widget _renderItemText(DayIngredient ingredient) {
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

  Future<bool> _canDismissItem(
      DismissDirection direction, DayIngredient ingredient) {
    //swipe right
    if (direction == DismissDirection.startToEnd) {
      final isUnchecked = ingredient.hadQty == null ||
          ingredient.hadQty < ingredient.expectedQty;
      return Future.value(isUnchecked);
      //swipe left
    } else if (direction == DismissDirection.endToStart) {
      final isChecked = ingredient.hadQty != null;
      return Future.value(isChecked);
    } else {
      return Future.value(false);
    }
  }

  void _onItemDismissed(DismissDirection direction, BuildContext context,
      DayIngredient ingredient, ScopedDayIngredient scopedIngredient) {
    final originalQty = ingredient.hadQty;
    //swipe right
    if (direction == DismissDirection.startToEnd) {
      scopedIngredient.updateIngredientQty(ingredient, ingredient.expectedQty);
      _notifyQtyUpdate("Ingredient checked", context, ingredient,
          scopedIngredient, originalQty);
      //swipe right
    } else if (direction == DismissDirection.endToStart) {
      scopedIngredient.updateIngredientQty(ingredient, null);
      _notifyQtyUpdate("Ingredient unchecked", context, ingredient,
          scopedIngredient, originalQty);
    }
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
