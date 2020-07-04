import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard(this.order);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) =>
            _renderContent(context, order, scopedOrder));
  }

  Widget _renderContent(
      BuildContext context, Order order, ScopedOrder scopedOrder) {
    var textWidgets = List<Widget>();

    textWidgets.add(Text("Order ID: ${order.id}"));

    order.items
        .forEach((item) => textWidgets.add(_renderItem(item, scopedOrder)));

    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: textWidgets));
  }

  Widget _renderItem(OrderItem item, ScopedOrder scopedOrder) {
    var recipe = scopedOrder.recipesMap[item.recipeId];
    return Text("${item.quantity} ${recipe.name}");
  }
}
