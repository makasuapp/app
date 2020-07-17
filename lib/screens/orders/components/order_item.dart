import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_data.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';

class OrderItemItem extends StatelessWidget {
  final OrderItem item;

  OrderItemItem(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedData>(
        builder: (context, child, scopedData) => _renderContent(scopedData));
  }

  Widget _renderContent(ScopedData scopedData) {
    final recipe = scopedData.recipesMap[item.recipeId];
    final text = "${item.quantity} ${recipe.name}";

    if (this.item.doneAtSec != null) {
      return Text(text, style: OrderStyles.doneItemText);
    } else {
      return Text(text, style: OrderStyles.orderItemText);
    }
  }
}
