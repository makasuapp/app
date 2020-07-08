import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import '../../../models/order.dart';
import '../order_styles.dart';
import '../order_details.dart';
import './order_item.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard(this.order);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) => InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => OrderDetailsPage(this.order)));
            },
            child: _renderContent(context, scopedOrder)));
  }

  Widget _renderContent(BuildContext context, ScopedOrder scopedOrder) {
    var contentWidgets = List<Widget>();

    contentWidgets.add(_renderTop(scopedOrder));
    contentWidgets.add(Container(padding: OrderStyles.orderItemsTopPadding));

    this.order.items.forEach((item) => contentWidgets.add(OrderItemItem(item)));

    return Container(
        padding: OrderStyles.orderCardPadding,
        decoration: BoxDecoration(
            border: Border.all(
          color: _cardColor(),
          width: 5,
        )),
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentWidgets));
  }

  Widget _renderTop(ScopedOrder scopedOrder) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _renderInfo()),
      Row(children: _renderButtons(scopedOrder))
    ]);
  }

  List<Widget> _renderInfo() {
    final orderState = this.order.orderState();
    var info = List<Widget>();
    final forTime = DateFormat('M/dd K:mm a').format(this.order.forTime());

    info.add(_renderText("Order ID: ${this.order.id}"));
    info.add(_renderText("For: $forTime"));
    info.add(_renderText("Status: ${orderState.text}"));

    if (orderState == OrderState.done()) {
      info.add(_renderText("Type: ${this.order.orderType}"));
      info.add(_renderText("Customer Info: ${this.order.customer.info()}"));
    }

    return info;
  }

  Widget _renderText(String text) {
    return Text(text);
  }

  List<Widget> _renderButtons(ScopedOrder scopedOrder) {
    var buttons = List<Widget>();

    if (this.order.orderState() != OrderState.delivered()) {
      buttons.add(IconButton(
          icon: Icon(Icons.assignment_turned_in),
          onPressed: () => scopedOrder.moveToNextState(this.order)));
    }
    return buttons;
  }

  Color _cardColor() {
    final orderState = this.order.orderState();
    final now = DateTime.now();
    //5 minutes before and still haven't started
    if (orderState == OrderState.newOrder() &&
        this.order.forTimeSec() <=
            now.subtract(Duration(minutes: 5)).millisecondsSinceEpoch) {
      return OrderStyles.orderOverdueColor;
    } else if (orderState == OrderState.started()) {
      return OrderStyles.orderStartedColor;
    } else {
      return OrderStyles.orderDefaultColor;
    }
  }
}