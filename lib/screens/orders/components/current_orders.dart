import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/scoped_models/scoped_lookup.dart';
import '../../common/components/swipable.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../order_styles.dart';
import '../../story/components/order_story_item.dart';
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
    _height = _minHeight + 30.0;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedOrder>(
        builder: (_, __, scopedOrder) => ScopedModelDescendant<ScopedLookup>(
            builder: (_, __, scopedLookup) =>
                _renderSheet(context, scopedOrder, scopedLookup)));
  }

  Widget _renderSheet(BuildContext context, ScopedOrder scopedOrder,
      ScopedLookup scopedLookup) {
    final currentState = OrderState.started();
    //started orders with not yet done items
    final currentOrders = scopedOrder
        .getOrders()
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
          child: _dragSizable(
              _renderOrders(currentOrders, scopedOrder, scopedLookup)));
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

  Widget _renderOrders(
      List<Order> orders, ScopedOrder scopedOrder, ScopedLookup scopedLookup) {
    var itemsByRecipe = Map<int, CurrentOrderItem>();
    orders.forEach(
        (o) => o.items.where((oi) => oi.doneAtSec == null).forEach((oi) {
              if (itemsByRecipe.containsKey(oi.recipeId)) {
                itemsByRecipe[oi.recipeId] =
                    itemsByRecipe[oi.recipeId].concat(oi);
              } else {
                itemsByRecipe[oi.recipeId] = CurrentOrderItem.from(oi);
              }
            }));

    return Wrap(children: [
      Container(
          width: double.infinity,
          padding: OrderStyles.currentOrdersPadding,
          child: Column(
              children: <Widget>[
                    Icon(Icons.drag_handle, color: Colors.black),
                    _renderHeader()
                  ] +
                  itemsByRecipe.values
                      .map((coi) =>
                          _renderOrderItem(coi, scopedOrder, scopedLookup))
                      .toList()))
    ]);
  }

  Widget _renderHeader() {
    return Container(
        width: double.infinity, child: Text("Remaining Started Items"));
  }

  Widget _renderOrderItem(CurrentOrderItem item, ScopedOrder scopedOrder,
      ScopedLookup scopedLookup) {
    final recipe = scopedLookup.getRecipe(item.recipeId);

    return Swipable(
        onSwipeRight: (_) => _onItemDismissed(item, scopedOrder),
        child: InkWell(
            onTap: () => StoryView.render(context,
                OrderStoryItem(recipe, servingSize: item.totalQty.toDouble())),
            child: Container(
                width: double.infinity,
                padding: OrderStyles.orderDetailItemPadding,
                child: Text("${item.totalQty} ${recipe.name}",
                    style: OrderStyles.orderItemText))));
  }

  void _onItemDismissed(CurrentOrderItem item, ScopedOrder scopedOrder) {
    final itemsMap = Map<int, OrderItem>.fromIterable(item.comprisedItems,
        key: (i) => i.id, value: (i) => i);
    scopedOrder.markItemsDoneTime(itemsMap, DateTime.now());
  }
}

class CurrentOrderItem {
  final int totalQty;
  final int recipeId;
  final List<OrderItem> comprisedItems;

  CurrentOrderItem(this.totalQty, this.recipeId, this.comprisedItems);

  factory CurrentOrderItem.from(OrderItem oi) {
    return CurrentOrderItem(oi.quantity, oi.recipeId, [oi]);
  }

  CurrentOrderItem concat(OrderItem oi) {
    return CurrentOrderItem(
        this.totalQty + oi.quantity, this.recipeId, this.comprisedItems + [oi]);
  }
}
