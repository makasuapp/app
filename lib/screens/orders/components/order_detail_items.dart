import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';
import '../../../styles.dart';
import '../components/order_item.dart';

class OrderDetailItems extends StatelessWidget {
  final int orderId;

  OrderDetailItems(this.orderId);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) =>
            _renderContent(context, scopedOrder));
  }

  //we don't want to pass in order from order_details since it doesn't update with the scoped order, so it might not be up to date
  //this doesn't seem like the correct thing to do...
  Order _order(ScopedOrder scopedOrder) =>
      scopedOrder.orders.where((o) => o.id == this.orderId).first;

  Widget _renderContent(BuildContext context, ScopedOrder scopedOrder) {
    return Column(
        children: _order(scopedOrder)
            .items
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
      scopedOrder.markItemDoneTime(_order(scopedOrder), item, DateTime.now());
      //swipe left
    } else if (direction == DismissDirection.endToStart) {
      scopedOrder.markItemDoneTime(_order(scopedOrder), item, null);
    }
  }
}
