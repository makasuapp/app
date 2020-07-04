import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import '../services/web_api.dart';
import '../service_locator.dart';
import '../models/recipe.dart';
import '../models/recipe_step.dart';
import '../models/order.dart';

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

  Future<void> _fetchOrders() async {
    final resp = await this.api.fetchOrdersJson();
    final decodedResp = json.decode(resp);

    final recipes =
        decodedResp["recipes"].map((recipeJson) => Recipe.fromJson(recipeJson));
    recipes.forEach((recipe) => this.recipesMap[recipe.id] = recipe);

    final recipeSteps = decodedResp["recipe_steps"]
        .map((recipeStepJson) => RecipeStep.fromJson(recipeStepJson));
    recipeSteps.forEach((step) => this.recipeStepsMap[step.id] = step);

    var orders = List<Order>();
    decodedResp["orders"]
        .forEach((orderJson) => orders.add(Order.fromJson(orderJson)));
    this.orders = orders;
  }
}
