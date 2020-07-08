import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';

class OrderItemItem extends StatelessWidget {
  final OrderItem item;

  OrderItemItem(this.item);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) => _renderContent(scopedOrder));
  }

  Widget _renderContent(ScopedOrder scopedOrder) {
    final recipe = scopedOrder.recipesMap[item.recipeId];
    final text = "${item.quantity} ${recipe.name}";

    if (this.item.doneAtSec != null) {
      return Text(text, style: OrderStyles.doneItemText);
    } else {
      return Text(text, style: OrderStyles.orderItemText);
    }
  }
}
