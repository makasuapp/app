import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../scoped_models/scoped_op_day.dart';
import '../../../models/day_ingredient.dart';
import '../adjust_quantity.dart';
import '../morning_styles.dart';

class MorningList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOpDay>(
      builder: (context, child, scopedOpDay) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _renderView(context, scopedOpDay)
        )
      )
    );
  }

  List<Widget> _renderView(BuildContext context, ScopedOpDay scopedOpDay) {
    var uncheckedIngredients = List<DayIngredient>();
    var missingIngredients = List<DayIngredient>();
    var checkedIngredients = List<DayIngredient>();

    scopedOpDay.ingredients.forEach((ingredient) => {
      if (ingredient.hadQty == null) {
        uncheckedIngredients.add(ingredient)
      } else if (ingredient.expectedQty != ingredient.hadQty) {
        missingIngredients.add(ingredient)
      } else {
        checkedIngredients.add(ingredient)
      }
    });

    var viewItems = List<Widget>();
    viewItems.add(_headerText("Unchecked Ingredients"));
    viewItems.addAll(uncheckedIngredients.map((i) => 
      _renderListItem(context, i, scopedOpDay)).toList());

    if (missingIngredients.length > 0) {
      viewItems.add(_headerText("Missing Ingredients"));
      viewItems.addAll(missingIngredients.map((i) => 
        _renderListItem(context, i, scopedOpDay)).toList());
    }

    if (checkedIngredients.length > 0) {
      viewItems.add(_headerText("Checked Ingredients"));
      viewItems.addAll(checkedIngredients.map((i) => 
        _renderListItem(context, i, scopedOpDay)).toList());
    }

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }

  Widget _headerText(String text) {
    return Container(
      padding: MorningStyles.listHeaderPadding,
      child: Text(text.toUpperCase(), style: MorningStyles.listHeader)
    );
  }

  Widget _renderListItem(BuildContext context, DayIngredient ingredient, ScopedOpDay scopedOpDay) {
    return Dismissible(
      background: Container(color: Styles.swipeRightColor),
      secondaryBackground: Container(color: Styles.swipeLeftColor),
      confirmDismiss: (direction) => _canDismissItem(direction, ingredient),
      key: UniqueKey(),
      onDismissed: (direction) => _onItemDismissed(direction, context, ingredient, scopedOpDay),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdjustQuantityPage(ingredient, 
              (double setQty, BuildContext qtyViewContext) {
                final originalQty = ingredient.hadQty;
                scopedOpDay.updateIngredientQty(ingredient, setQty);
                Navigator.pop(qtyViewContext);
                _notifyQtyUpdate("Ingredient updated", context, ingredient, scopedOpDay, originalQty);
              }
            ))
          );
        },
        child: _renderItemText(ingredient)
      )
    );
  }

  Widget _renderItemText(DayIngredient ingredient) {
    final expectedText = ingredient.qtyWithUnit(ingredient.expectedQty);
    List<Widget> textWidgets = List();

    if (ingredient.hadQty != null && ingredient.hadQty != ingredient.expectedQty) {
      final hadText = ingredient.qtyWithUnit(ingredient.hadQty);
      textWidgets.add(Text("$hadText ", style: MorningStyles.unexpectedItemText));
      textWidgets.add(Text(expectedText, style: MorningStyles.expectedItemText));
    } else {
      textWidgets.add(Text(expectedText, style: MorningStyles.listItemText));
    }
    textWidgets.add(Text(" ${ingredient.name}", style: MorningStyles.listItemText));

    return Container(
      padding: MorningStyles.listItemPadding,
      child: Wrap(
        children: textWidgets
      )
    );
  }

  Future<bool> _canDismissItem(DismissDirection direction, DayIngredient ingredient) {
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

  void _onItemDismissed(DismissDirection direction, BuildContext context, DayIngredient ingredient, ScopedOpDay scopedOpDay) {
    final originalQty = ingredient.hadQty;
    //swipe right 
    if (direction == DismissDirection.startToEnd) {
      scopedOpDay.updateIngredientQty(ingredient, ingredient.expectedQty);
      _notifyQtyUpdate("Ingredient checked", context, ingredient, scopedOpDay, originalQty);
    //swipe right
    } else if (direction == DismissDirection.endToStart) {
      scopedOpDay.updateIngredientQty(ingredient, null);
      _notifyQtyUpdate("Ingredient unchecked", context, ingredient, scopedOpDay, originalQty);
    } 
  }

  void _notifyQtyUpdate(String notificationText, BuildContext context, DayIngredient ingredient,
    ScopedOpDay scopedOpDay, double originalQty) {
    Flushbar flush;
    flush = Flushbar(
      message: notificationText,
      duration: Duration(seconds: 3),
      isDismissible: true,
      mainButton: InkWell(
        onTap: () {
          scopedOpDay.updateIngredientQty(ingredient, originalQty);
          flush.dismiss(); 
        },
        child: Text("Undo", style: Styles.textHyperlink)
      )
    )..show(context);
  }
}