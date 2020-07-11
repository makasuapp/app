import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:meta/meta.dart';
import '../api/load_orders_response.dart';
import '../api/order_item_update.dart';
import '../services/web_api.dart';
import '../service_locator.dart';
import '../models/recipe.dart';
import '../models/recipe_step.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class ScopedOrder extends Model {
  Map<int, Recipe> recipesMap = Map();
  Map<int, RecipeStep> recipeStepsMap = Map();
  List<Order> orders;
  bool isLoading = false;
  WebApi api;

  DateTime _lastLoaded;

  ScopedOrder(
      {List<Recipe> recipes, List<RecipeStep> recipeSteps, orders, api}) {
    this.api = api ?? locator<WebApi>();
    if (recipes != null) {
      recipes.forEach((recipe) => this.recipesMap[recipe.id] = recipe);
    }
    if (recipeSteps != null) {
      recipeSteps.forEach((step) => this.recipeStepsMap[step.id] = step);
    }
    this.orders = orders ?? List();
  }

  Future<void> loadOrders({forceLoad = false}) async {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);

    if (forceLoad ||
        this._lastLoaded == null ||
        this._lastLoaded.millisecondsSinceEpoch <
            lastMidnight.millisecondsSinceEpoch) {
      this.isLoading = true;
      notifyListeners();

      await _fetchOrders();

      this.isLoading = false;
      this._lastLoaded = now;

      notifyListeners();
    }
  }

  @visibleForTesting
  //TODO: move done to the back? and delivered to very back
  int sortOrderList(Order a, Order b) {
    return a.forTimeSec() - b.forTimeSec();
  }

  Future<void> _fetchOrders() async {
    final resp = await this.api.fetchOrdersJson();
    final decodedResp = json.decode(resp);
    final loadOrdersResp = LoadOrdersResponse.fromJson(decodedResp);

    loadOrdersResp.recipes
        .forEach((recipe) => this.recipesMap[recipe.id] = recipe);
    loadOrdersResp.recipeSteps
        .forEach((step) => this.recipeStepsMap[step.id] = step);

    var orders = loadOrdersResp.orders;
    orders.sort((a, b) => sortOrderList(a, b));
    this.orders = orders;
  }

  void moveToNextState(Order order) async {
    final orderState = order.orderState();
    final updatedOrder = Order.clone(order, state: orderState.next);
    final updatedOrders =
        this.orders.map((o) => o.id == order.id ? updatedOrder : o).toList();
    this.orders = updatedOrders;
    //TODO: sort again
    notifyListeners();

    try {
      await this.api.postOrderUpdateState(order);
    } catch (err) {
      print(err);
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
      print(err);
      this.orders = originalOrders;
      notifyListeners();
    }
  }
}
