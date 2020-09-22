import 'package:flutter/material.dart';
import 'package:kitchen/screens/orders/components/comment.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';
import '../../story/components/order_story_item.dart';
import '../../story/story.dart';
import '../../common/components/swipable.dart';

class OrderItems extends StatelessWidget {
  final int orderId;

  OrderItems(this.orderId);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (_, __, scopedOrder) => ScopedModelDescendant<ScopedLookup>(
            builder: (_, __, scopedLookup) =>
                _renderContent(context, scopedOrder, scopedLookup)));
  }

  //we don't want to pass in order from order_details since it doesn't update with the scoped order, so it might not be up to date
  //this doesn't seem like the correct thing to do...
  Order _order(ScopedOrder scopedOrder) =>
      scopedOrder.getOrders().where((o) => o.id == this.orderId).first;

  Widget _renderContent(BuildContext context, ScopedOrder scopedOrder,
      ScopedLookup scopedLookup) {
    return Column(
        children: _order(scopedOrder)
            .items
            .map(
                (item) => _renderItem(context, item, scopedOrder, scopedLookup))
            .toList());
  }

  Widget _renderItem(BuildContext context, OrderItem item,
      ScopedOrder scopedOrder, ScopedLookup scopedLookup) {
    final isDone = item.doneAtSec != null;
    return Swipable(
        canSwipeLeft: () => Future.value(isDone),
        canSwipeRight: () => Future.value(!isDone),
        onSwipeRight: (_) =>
            scopedOrder.markItemsDoneTime({item.id: item}, DateTime.now()),
        onSwipeLeft: (_) =>
            scopedOrder.markItemsDoneTime({item.id: item}, null),
        child: InkWell(
            onTap: () => StoryView.render(
                context,
                OrderStoryItem(scopedLookup.getRecipe(item.recipeId),
                    servingSize: item.quantity.toDouble())),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: OrderStyles.orderDetailItemPadding,
                child: _renderItemText(scopedLookup, item))));
  }

  Widget _renderItemText(ScopedLookup scopedLookup, OrderItem item) {
    final recipe = scopedLookup.getRecipe(item.recipeId);
    final text = "${item.quantity} ${recipe.name}";

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,
              style: item.doneAtSec != null
                  ? OrderStyles.doneItemText
                  : OrderStyles.orderItemText),
          Comment(item.comment)
        ]);
  }
}
