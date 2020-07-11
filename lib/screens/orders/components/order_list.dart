import 'package:flutter/material.dart';
import 'package:kitchen/models/order.dart';
import 'package:kitchen/styles.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import './order_card.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) => SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _renderView(context, scopedOrder))));
  }

  List<Widget> _renderView(BuildContext context, ScopedOrder scopedOrder) {
    var viewItems = List<Widget>();

    viewItems.addAll(scopedOrder.orders
        .where((o) => o.orderState() != OrderState.delivered())
        .map((o) => OrderCard(o))
        .toList());

    viewItems.add(Container(padding: Styles.spacerPadding));

    return viewItems;
  }
}
