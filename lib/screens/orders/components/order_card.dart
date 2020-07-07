import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard(this.order);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) =>
            _renderContent(context, scopedOrder));
  }

  Widget _renderContent(BuildContext context, ScopedOrder scopedOrder) {
    var contentWidgets = List<Widget>();

    contentWidgets.addAll(_renderInfo());
    contentWidgets.add(Container(padding: OrderStyles.orderItemsTopPadding));

    this
        .order
        .items
        .forEach((item) => contentWidgets.add(_renderItem(item, scopedOrder)));

    return Container(
        padding: OrderStyles.orderCardPadding,
        color: _cardColor(),
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentWidgets));
  }

  Widget _renderText(String text) {
    return Text(text);
  }

  List<Widget> _renderInfo() {
    final orderState = this.order.orderState();
    var info = List<Widget>();
    final forTime = DateFormat('M/dd K:mm a').format(this.order.forTime());

    info.add(_renderText("Order ID: ${this.order.id}"));
    info.add(_renderText("For: $forTime"));
    info.add(_renderText("Status: ${this.order.state}"));

    if (orderState == OrderState.Done) {
      info.add(_renderText("Type: ${this.order.orderType}"));
      info.add(_renderText("Customer Info: ${this.order.customer.info()}"));
    }

    return info;
  }

  Widget _renderItem(OrderItem item, ScopedOrder scopedOrder) {
    var recipe = scopedOrder.recipesMap[item.recipeId];
    return Text("${item.quantity} ${recipe.name}",
        style: OrderStyles.orderItemText);
  }

  Color _cardColor() {
    final orderState = this.order.orderState();
    final now = DateTime.now();
    //5 minutes before and still haven't started
    if (orderState == OrderState.New &&
        this.order.forTimeSec() <=
            now.subtract(Duration(minutes: 5)).millisecondsSinceEpoch) {
      return OrderStyles.orderOverdueColor;
    } else if (orderState == OrderState.Started) {
      return OrderStyles.orderStartedColor;
    } else {
      return OrderStyles.orderDefaultColor;
    }
  }
}
