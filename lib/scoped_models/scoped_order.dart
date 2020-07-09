import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:meta/meta.dart';
import '../api/load_orders_response.dart';
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
    notifyListeners();

    try {
      await this.api.postOrderUpdateState(order);
    } catch (err) {
      print(err);
      final revertedOrders =
          this.orders.map((o) => o.id == order.id ? order : o).toList();
      this.orders = revertedOrders;
      notifyListeners();
    }
  }

  void markItemDoneTime(Order parentOrder, OrderItem item, DateTime doneAt) {
    final updatedItem = OrderItem.clone(item, item.startedAtSec,
        doneAt != null ? doneAt.millisecondsSinceEpoch ~/ 1000 : null);

    final updatedOrders = this.orders.map((o) {
      if (o.id == parentOrder.id) {
        final updatedItems = parentOrder.items
            .map((i) => i.id == updatedItem.id ? updatedItem : i)
            .toList();
        return Order.clone(parentOrder, items: updatedItems);
      } else {
        return o;
      }
    }).toList();
    this.orders = updatedOrders;
    notifyListeners();

    //TODO: make api request
  }
}
