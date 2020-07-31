import 'package:flutter/material.dart';
import 'package:kitchen/models/procurement_item.dart';
import 'package:kitchen/models/step_input.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/screens/common/components/input_with_quantity.dart';
import 'package:scoped_model/scoped_model.dart';

class ShoppingListItem extends StatelessWidget {
  final ProcurementItem item;

  ShoppingListItem(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedLookup>(
        builder: (context, child, scopedLookup) {
      final ingredient = scopedLookup.ingredientsMap[item.ingredientId];
      return InputWithQuantity(
          ingredient.name, item.quantity, InputType.Ingredient, item.unit,
          adjustedInputQty: item.gotQty, adjustedInputUnit: item.gotUnit);
    });
  }
}
