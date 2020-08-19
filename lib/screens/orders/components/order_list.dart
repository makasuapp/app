import 'package:flutter/material.dart';
import 'package:kitchen/models/order.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import './order_card.dart';
import '../order_styles.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) => ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: _renderView(context, scopedOrder)));
  }

  List<Widget> _renderView(BuildContext context, ScopedOrder scopedOrder) {
    return scopedOrder.orders
            .where((o) => o.orderState() != OrderState.delivered())
            .map<Widget>((o) => OrderCard(o))
            .toList() +
        <Widget>[Container(padding: OrderStyles.orderListBottomPadding)];
  }
}
