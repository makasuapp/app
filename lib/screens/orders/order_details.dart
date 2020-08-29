import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:intl/intl.dart';
import 'components/order_items.dart';
import './order_styles.dart';
import '../../service_locator.dart';

class OrderDetailsArguments {
  final int orderId;

  OrderDetailsArguments(this.orderId);
}

class OrderDetailsPage extends StatelessWidget {
  static const routeName = '/order_details';

  final int orderId;
  final scopedOrder = locator<ScopedOrder>();
  final scopedLookup = locator<ScopedLookup>();

  OrderDetailsPage(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Order ${this.orderId}")),
        body: ScopedModel<ScopedOrder>(
            model: this.scopedOrder,
            child: ScopedModel<ScopedLookup>(
                model: this.scopedLookup,
                child: Container(child: _renderContent(context)))));
  }

  Widget _renderContent(BuildContext context) {
    return Container(
        padding: OrderStyles.orderCardPadding,
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _renderInfo() +
                <Widget>[
                  Container(padding: OrderStyles.orderItemsTopPadding),
                  OrderItems(this.orderId)
                ]));
  }

  List<Widget> _renderInfo() {
    final order = this
        .scopedOrder
        .orders
        .where((order) => order.id == this.orderId)
        .first;
    final orderState = order.orderState();
    final forTime = DateFormat('M/dd K:mm a').format(order.forTime());

    return <Widget>[
      _renderText("Order ID: ${order.orderId}"),
      _renderText("For: $forTime"),
      _renderText("Status: ${orderState.text}"),
      _renderText("Type: ${order.orderType}"),
      _renderText("Customer Info: ${order.customer.info()}"),
    ];
  }

  Widget _renderText(String text) {
    return Text(text);
  }
}
