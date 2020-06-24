import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../scoped_models/scoped_inventory.dart';
import '../../../models/day_ingredient.dart';
import '../adjust_quantity.dart';
import '../inventory_styles.dart';

class InventoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedInventory>(
      builder: (context, child, scopedInventory) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _renderView(context, scopedInventory)
        )
      )
    );
  }

  List<Widget> _renderView(BuildContext context, ScopedInventory scopedInventory) {
    var uncheckedIngredients = List<DayIngredient>();
    var missingIngredients = List<DayIngredient>();
    var checkedIngredients = List<DayIngredient>();

    scopedInventory.ingredients.forEach((ingredient) => {
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
      _inventoryListItem(context, i, scopedInventory)).toList());

    if (missingIngredients.length > 0) {
      viewItems.add(_headerText("Missing Ingredients"));
      viewItems.addAll(missingIngredients.map((i) => 
        _inventoryListItem(context, i, scopedInventory)).toList());
    }

    if (checkedIngredients.length > 0) {
      viewItems.add(_headerText("Checked Ingredients"));
      viewItems.addAll(checkedIngredients.map((i) => 
        _inventoryListItem(context, i, scopedInventory)).toList());
    }

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }

  Widget _headerText(String text) {
    return Container(
      padding: InventoryStyles.headerPadding,
      child: Text(text.toUpperCase(), style: InventoryStyles.listHeader)
    );
  }

  Widget _inventoryListItem(BuildContext context, DayIngredient ingredient, ScopedInventory scopedInventory) {
    return Dismissible(
      background: Container(color: InventoryStyles.inventorySwipeRightColor),
      secondaryBackground: Container(color: InventoryStyles.inventorySwipeLeftColor),
      confirmDismiss: (direction) => _canDismissItem(direction, ingredient),
      key: UniqueKey(),
      onDismissed: (direction) => _onItemDismissed(direction, context, ingredient, scopedInventory),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdjustQuantityPage(ingredient, 
              (double setQty, BuildContext qtyViewContext) {
                final originalQty = ingredient.hadQty;
                scopedInventory.updateIngredientQty(ingredient, setQty);
                Navigator.pop(qtyViewContext);
                _notifyQtyUpdate("Ingredient updated", context, ingredient, scopedInventory, originalQty);
              }
            ))
          );
        },
        child: _renderInventoryItemText(ingredient)
      )
    );
  }

  Widget _renderInventoryItemText(DayIngredient ingredient) {
    final expectedText = ingredient.qtyWithUnit(ingredient.expectedQty);
    List<Widget> textWidgets = List();

    if (ingredient.hadQty != null && ingredient.hadQty != ingredient.expectedQty) {
      final hadText = ingredient.qtyWithUnit(ingredient.hadQty);
      textWidgets.add(Text("$hadText ", style: InventoryStyles.unexpectedItemText));
      textWidgets.add(Text(expectedText, style: InventoryStyles.expectedItemText));
    } else {
      textWidgets.add(Text(expectedText, style: InventoryStyles.inventoryItemText));
    }
    textWidgets.add(Text(" ${ingredient.name}", style: InventoryStyles.inventoryItemText));

    return Container(
      padding: InventoryStyles.inventoryItemPadding,
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

  void _onItemDismissed(DismissDirection direction, BuildContext context, DayIngredient ingredient, ScopedInventory scopedInventory) {
    final originalQty = ingredient.hadQty;
    //swipe right 
    if (direction == DismissDirection.startToEnd) {
      scopedInventory.updateIngredientQty(ingredient, ingredient.expectedQty);
      _notifyQtyUpdate("Ingredient checked", context, ingredient, scopedInventory, originalQty);
    //swipe right
    } else if (direction == DismissDirection.endToStart) {
      scopedInventory.updateIngredientQty(ingredient, null);
      _notifyQtyUpdate("Ingredient unchecked", context, ingredient, scopedInventory, originalQty);
    } 
  }

  void _notifyQtyUpdate(String notificationText, BuildContext context, DayIngredient ingredient,
    ScopedInventory scopedInventory, double originalQty) {
    Flushbar flush;
    flush = Flushbar(
      message: notificationText,
      duration: Duration(seconds: 3),
      isDismissible: true,
      mainButton: InkWell(
        onTap: () {
          scopedInventory.updateIngredientQty(ingredient, originalQty);
          flush.dismiss(); 
        },
        child: Text("Undo", style: Styles.textHyperlink)
      )
    )..show(context);
  }
}