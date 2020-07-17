import 'package:flutter/material.dart';
import 'package:kitchen/service_locator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/scoped_models/scoped_data.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';
import '../components/order_item.dart';
import '../../story/components/recipe_story_item.dart';
import '../../story/story.dart';
import '../../common/swipable.dart';

class OrderDetailItems extends StatelessWidget {
  final int orderId;

  OrderDetailItems(this.orderId);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (_, __, scopedOrder) => ScopedModelDescendant<ScopedData>(
            builder: (_, __, scopedData) =>
                _renderContent(context, scopedOrder, scopedData)));
  }

  //we don't want to pass in order from order_details since it doesn't update with the scoped order, so it might not be up to date
  //this doesn't seem like the correct thing to do...
  Order _order(ScopedOrder scopedOrder) =>
      scopedOrder.orders.where((o) => o.id == this.orderId).first;

  Widget _renderContent(
      BuildContext context, ScopedOrder scopedOrder, ScopedData scopedData) {
    return Column(
        children: _order(scopedOrder)
            .items
            .map((item) => _renderItem(context, item, scopedOrder, scopedData))
            .toList());
  }

  Widget _renderItem(BuildContext context, OrderItem item,
      ScopedOrder scopedOrder, ScopedData scopedData) {
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
                context, RecipeStoryItem(scopedData.recipesMap[item.recipeId])),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: OrderStyles.orderDetailItemPadding,
                child: OrderItemItem(item))));
  }
}
