import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../scoped_models/scoped_inventory.dart';
import '../../../models/day_ingredient.dart';
import 'package:kitchen/styles.dart';

class InventoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedInventory>(
      builder: (context, child, scopedInventory) => Column(children: [
        Text("Ingredients"),
        Expanded(child: ListView(
          children: scopedInventory.ingredients
            .map((i) => _inventoryListItem(i))
            .toList()
        ))
      ])
    );
  }

  Widget _inventoryListItem(DayIngredient ingredient) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Styles.verticalPaddingDefault,
        horizontal: Styles.horizontalPaddingDefault
      ),
      child: Text("${ingredient.expectedQtyWithUnit()} ${ingredient.name}", style: Styles.textDefault)
    );
  }
}