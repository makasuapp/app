import 'package:flutter/material.dart';
import '../inventory_styles.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../scoped_models/scoped_inventory.dart';
import '../../../models/day_ingredient.dart';

class InventoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedInventory>(
      builder: (context, child, scopedInventory) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _renderView(scopedInventory.ingredients)
        )
      )
    );
  }

  List<Widget> _renderView(List<DayIngredient> ingredients) {
    var uncheckedIngredients = List<DayIngredient>();
    var missingIngredients = List<DayIngredient>();
    var checkedIngredients = List<DayIngredient>();

    ingredients.forEach((ingredient) => {
      if (ingredient.hadQty == null) {
        uncheckedIngredients.add(ingredient)
      } else if (ingredient.expectedQty > ingredient.hadQty) {
        checkedIngredients.add(ingredient)
      } else {
        missingIngredients.add(ingredient)
      }
    });

    var viewItems = List<Widget>();
    viewItems.add(_headerText("Unchecked Ingredients"));
    viewItems.addAll(uncheckedIngredients.map((i) => _inventoryListItem(i)).toList());

    if (missingIngredients.length > 0) {
      viewItems.add(_headerText("Missing Ingredients"));
      viewItems.addAll(missingIngredients.map((i) => _inventoryListItem(i)).toList());
    }

    if (checkedIngredients.length > 0) {
      viewItems.add(_headerText("Checked Ingredients"));
      viewItems.addAll(checkedIngredients.map((i) => _inventoryListItem(i)).toList());
    }

    return viewItems;
  }

  Widget _headerText(String text) {
    return Container(
      padding: InventoryStyles.headerPadding,
      child: Text(text.toUpperCase(), style: InventoryStyles.listHeader)
    );
  }

  Widget _inventoryListItem(DayIngredient ingredient) {
    return Container(
      padding: InventoryStyles.inventoryItemPadding,
      child: Text("${ingredient.expectedQtyWithUnit()} ${ingredient.name}", style: InventoryStyles.inventoryItemText)
    );
  }
}