import 'package:flutter/material.dart';
import 'package:kitchen/models/procurement_item.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:kitchen/scoped_models/scoped_procurement.dart';
import 'package:scoped_model/scoped_model.dart';
import 'shopping_list_item.dart';

class SwipableShoppingItem extends StatelessWidget {
  final ProcurementItem item;

  SwipableShoppingItem(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedLookup>(
        builder: (context, child, scopedLookup) =>
            ScopedModelDescendant<ScopedProcurement>(
                builder: (context, child, scopedProcurement) {
              return ShoppingListItem(item);
            }));
  }
}
