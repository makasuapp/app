import 'dart:convert';
import 'package:meta/meta.dart';
import '../api/load_orders_response.dart';
import '../api/order_item_update.dart';
import '../services/web_api.dart';
import '../services/logger.dart';
import '../service_locator.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import './scoped_api_model.dart';
import 'scoped_lookup.dart';
class ScopedOrder extends ScopedApiModel {
  List<Order> orders;
  Map<int, Order> newUnseenOrders = Map();
  static ScopedLookup _scopedLookup = locator<ScopedLookup>();

  ScopedOrder({List<Order> orders, WebApi api, ScopedLookup scopedLookup})
      : super(api: api) {
    this.orders = orders ?? List();

    if (scopedLookup != null) {
      _scopedLookup = scopedLookup;
    }
  }

  Future<void> loadOrders({forceLoad = false}) async {
    loadData(() async {
      await _fetchOrders();
    }, forceLoad: forceLoad);
  }

  @visibleForTesting
  //TODO: move done to the back? and delivered to very back
  int compareForOrderList(Order a, Order b) {
    return a.forTimeSec() - b.forTimeSec();
  }

  Future<void> _fetchOrders() async {
    final resp = await this.api.fetchOrdersJson();
    final decodedResp = json.decode(resp);
    final loadOrdersResp = LoadOrdersResponse.fromJson(decodedResp);

    _scopedLookup.addData(
        recipes: loadOrdersResp.recipes,
        recipeSteps: loadOrdersResp.recipeSteps,
        ingredients: loadOrdersResp.ingredients);
    var orders = loadOrdersResp.orders;
    orders.sort((a, b) => compareForOrderList(a, b));
    this.orders = orders;
  }

  void moveToNextState(Order order) async {
    final orderState = order.orderState();
    final updatedOrder = Order.clone(order, state: orderState.next);
    final updatedOrders =
        this.orders.map((o) => o.id == order.id ? updatedOrder : o).toList();
    this.orders = updatedOrders;
    clearUnseenOrders();
    //TODO: sort again
    notifyListeners();

    try {
      await this.api.postOrderUpdateState(order);
    } catch (err) {
      Logger.error(err);
      //TODO: save update locally to retry later instead
      final revertedOrders =
          this.orders.map((o) => o.id == order.id ? order : o).toList();
      this.orders = revertedOrders;
      notifyListeners();
    }
  }

  void markItemsDoneTime(Map<int, OrderItem> itemsById, DateTime doneAt) async {
    final originalOrders = this.orders;
    final updatedOrders = this.orders.map((o) {
      final updatedItems = o.items.map((i) {
        if (itemsById.containsKey(i.id)) {
          final updatedItem = OrderItem.clone(i, i.startedAtSec,
              doneAt != null ? doneAt.millisecondsSinceEpoch ~/ 1000 : null);
          return updatedItem;
        } else {
          return i;
        }
      }).toList();
      return Order.clone(o, items: updatedItems);
    }).toList();
    this.orders = updatedOrders;
    notifyListeners();

    final orderItemUpdates = itemsById.values
        .map((i) => doneAt != null
            ? OrderItemUpdate.forDoneAt(i.id, doneAt, doneAt)
            : OrderItemUpdate.clearDoneAt(i.id, DateTime.now()))
        .toList();
    try {
      await this.api.postOrderItemUpdates(orderItemUpdates);
    } catch (err) {
      Logger.error(err);
      this.orders = originalOrders;
      notifyListeners();
    }
  }


  void addOrder(Order order){
    this.orders.add(order);
    this.orders.sort((a,b) => compareForOrderList(a, b));
    this.newUnseenOrders[order.id] = order;
    notifyListeners();
  }

  void clearUnseenOrders(){
    this.newUnseenOrders.clear();
    notifyListeners();
  }
}
