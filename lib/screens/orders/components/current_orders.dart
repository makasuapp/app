import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';
import '../../../styles.dart';
import '../../story/components/recipe_story_item.dart';
import '../../story/story.dart';

class CurrentOrders extends StatefulWidget {
  @override
  createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  static const _minHeight = 40.0;
  double _height;

  @override
  void initState() {
    super.initState();
    _height = _minHeight;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (context, child, scopedOrder) =>
            _renderSheet(context, scopedOrder));
  }

  Widget _renderSheet(BuildContext context, ScopedOrder scopedOrder) {
    final currentState = OrderState.started();
    //started orders with not yet done items
    final currentOrders = scopedOrder.orders
        .where((o) =>
            o.orderState() == currentState &&
            o.items.where((oi) => oi.doneAtSec == null).length > 0)
        .toList();

    if (currentOrders.length > 0) {
      return Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: OrderStyles.currentOrdersBorder))),
          height: _height,
          width: MediaQuery.of(context).size.width,
          child: _dragSizable(_renderOrders(currentOrders, scopedOrder)));
    } else {
      return Container(height: 0);
    }
  }

  Widget _dragSizable(Widget child) {
    return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          final newHeight =
              MediaQuery.of(context).size.height - details.globalPosition.dy;
          if (newHeight >= _minHeight) {
            setState(() => _height = newHeight);
          }
        },
        child: child);
  }

  Widget _renderOrders(List<Order> orders, ScopedOrder scopedOrder) {
    var widgets = List<Widget>();
    var itemsByRecipe = Map<int, CurrentOrderItem>();
    orders.forEach(
        (o) => o.items.where((oi) => oi.doneAtSec == null).forEach((oi) {
              if (itemsByRecipe.containsKey(oi.recipeId)) {
                itemsByRecipe[oi.recipeId] =
                    itemsByRecipe[oi.recipeId].concat(oi);
              } else {
                itemsByRecipe[oi.recipeId] =
                    CurrentOrderItem(oi.quantity, oi.recipeId, [oi]);
              }
            }));

    widgets.add(_renderHeader());
    widgets.addAll(itemsByRecipe.values
        .map((coi) => _renderOrderItem(coi, scopedOrder))
        .toList());

    return Wrap(children: [
      Container(
          width: double.infinity,
          padding: OrderStyles.currentOrdersPadding,
          child: Column(children: widgets))
    ]);
  }

  Widget _renderHeader() {
    return Container(
        width: double.infinity, child: Text("Remaining Started Items"));
  }

  Widget _renderOrderItem(CurrentOrderItem item, ScopedOrder scopedOrder) {
    final recipe = scopedOrder.recipesMap[item.recipeId];

    return Dismissible(
        background: Container(color: Styles.swipeRightColor),
        key: UniqueKey(),
        onDismissed: (direction) =>
            _onItemDismissed(direction, item, scopedOrder),
        child: InkWell(
            onTap: () => StoryView.render(context,
                RecipeStoryItem(scopedOrder.recipesMap[item.recipeId])),
            child: Container(
                width: double.infinity,
                padding: OrderStyles.orderDetailItemPadding,
                child: Text("${item.totalQty} ${recipe.name}",
                    style: OrderStyles.orderItemText))));
  }

  void _onItemDismissed(DismissDirection direction, CurrentOrderItem item,
      ScopedOrder scopedOrder) {
    //swipe right
    if (direction == DismissDirection.startToEnd) {
      final itemsMap = Map<int, OrderItem>.fromIterable(item.comprisedItems,
          key: (i) => i.id, value: (i) => i);
      scopedOrder.markItemsDoneTime(itemsMap, DateTime.now());
    }
  }
}

//TODO: test
class CurrentOrderItem {
  final int totalQty;
  final int recipeId;
  final List<OrderItem> comprisedItems;

  CurrentOrderItem(this.totalQty, this.recipeId, this.comprisedItems);

  CurrentOrderItem concat(OrderItem oi) {
    return CurrentOrderItem(
        this.totalQty + oi.quantity, this.recipeId, this.comprisedItems + [oi]);
  }
}
