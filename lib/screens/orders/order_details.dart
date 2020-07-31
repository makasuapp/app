import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import 'package:intl/intl.dart';
import 'components/order_items.dart';
import '../../models/order.dart';
import './order_styles.dart';
import '../../service_locator.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;
  final scopedOrder = locator<ScopedOrder>();
  final scopedLookup = locator<ScopedLookup>();

  OrderDetailsPage(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Order ${this.order.id}")),
        body: ScopedModel<ScopedOrder>(
            model: this.scopedOrder,
            child: ScopedModel<ScopedLookup>(
                model: this.scopedLookup,
                child: Container(child: _renderContent(context)))));
  }

  Widget _renderContent(BuildContext context) {
    var contentWidgets = List<Widget>();

    contentWidgets.addAll(_renderInfo());
    contentWidgets.add(Container(padding: OrderStyles.orderItemsTopPadding));
    contentWidgets.add(OrderItems(this.order.id));

    return Container(
        padding: OrderStyles.orderCardPadding,
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentWidgets));
  }

  List<Widget> _renderInfo() {
    final orderState = this.order.orderState();
    var info = List<Widget>();
    final forTime = DateFormat('M/dd K:mm a').format(this.order.forTime());

    info.add(_renderText("Order ID: ${this.order.id}"));
    info.add(_renderText("For: $forTime"));
    info.add(_renderText("Status: ${orderState.text}"));
    info.add(_renderText("Type: ${this.order.orderType}"));
    info.add(_renderText("Customer Info: ${this.order.customer.info()}"));

    return info;
  }

  Widget _renderText(String text) {
    return Text(text);
  }
}
