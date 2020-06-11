import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../scoped_models/scoped_inventory.dart';
import '../../../models/ingredient.dart';

class InventoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedInventory>(
      builder: (context, child, scopedInventory) => ListView(
        children: scopedInventory.ingredients
          .map((i) => _inventoryListItem(i))
          .toList()
      )
    );
  }

  Widget _inventoryListItem(Ingredient ingredient) {
    return Container(
      child: Text(ingredient.name)
    );
  }
}