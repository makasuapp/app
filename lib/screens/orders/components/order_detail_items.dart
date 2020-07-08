import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';
import '../../../styles.dart';
import '../components/order_item.dart';

class OrderDetailItems extends StatelessWidget {
  final Order order;

  OrderDetailItems(this.order);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) =>
            _renderContent(context, scopedOrder));
  }

  Widget _renderContent(BuildContext context, ScopedOrder scopedOrder) {
    //order may not be up to date since it's the one from order_details, which doesn't pick up on listener..?
    //this doesn't seem like the correct thing to do
    final order = scopedOrder.orders.where((o) => o.id == this.order.id).first;
    return Column(
        children: order.items
            .map((item) => _renderItem(context, item, scopedOrder))
            .toList());
  }

  Widget _renderItem(
      BuildContext context, OrderItem item, ScopedOrder scopedOrder) {
    return Dismissible(
        background: Container(color: Styles.swipeRightColor),
        secondaryBackground: Container(color: Styles.swipeLeftColor),
        confirmDismiss: (direction) => _canDismissItem(direction, item),
        key: UniqueKey(),
        onDismissed: (direction) =>
            _onItemDismissed(direction, context, item, scopedOrder),
        child: InkWell(
            onTap: () {
              //TODO: open recipe card modal
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: OrderStyles.orderDetailItemPadding,
                child: OrderItemItem(item))));
  }

  Future<bool> _canDismissItem(DismissDirection direction, OrderItem item) {
    final isDone = item.doneAtSec != null;
    //swipe right
    if (direction == DismissDirection.startToEnd) {
      return Future.value(!isDone);
      //swipe left
    } else if (direction == DismissDirection.endToStart) {
      return Future.value(isDone);
    } else {
      return Future.value(false);
    }
  }

  void _onItemDismissed(DismissDirection direction, BuildContext context,
      OrderItem item, ScopedOrder scopedOrder) {
    //swipe right
    if (direction == DismissDirection.startToEnd) {
      scopedOrder.markItemDoneTime(this.order, item, DateTime.now());
      //swipe left
    } else if (direction == DismissDirection.endToStart) {
      scopedOrder.markItemDoneTime(this.order, item, null);
    }
  }
}
