import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/ingredient_update.dart';
import '../api/prep_update.dart';
import '../api/procurement_update.dart';
import '../api/order_item_update.dart';
import '../models/order.dart';
import '../env.dart';

class WebApi {
  String apiScheme;
  String apiHost;
  final prefix = '/api';

  WebApi({apiScheme, apiHost}) {
    this.apiScheme = apiScheme ?? 'https';
    this.apiHost = apiHost ?? EnvironmentConfig.API_HOST;
  }

  Uri uri(String path, {Map<String, dynamic> queryParameters}) {
    final uri = new Uri(
        scheme: this.apiScheme,
        host: this.apiHost,
        path: '${this.prefix}$path',
        queryParameters: queryParameters);

    return uri;
  }

  Future<String> _fetchJson(String endpoint,
      {Map<String, dynamic> queryParameters}) async {
    final uri = this.uri(endpoint, queryParameters: queryParameters);
    final resp = await http.get(uri.toString());

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return resp.body;
  }

  Future<String> fetchRecipesJson() => this._fetchJson('/recipes');
  //TODO(multi-kitchen): actually pass in kitchen id
  Future<String> fetchOpDayJson() =>
      this._fetchJson('/op_days', queryParameters: {"kitchen_id": "1"});
  //TODO(multi-kitchen): actually pass in kitchen id
  Future<String> fetchOrdersJson() =>
      this._fetchJson('/orders', queryParameters: {"kitchen_id": "1"});
  //TODO(multi-kitchen): actually pass in kitchen id
  Future<String> fetchProcurementJson() =>
      this._fetchJson('/procurement', queryParameters: {"kitchen_id": "1"});

  Future<dynamic> _postJson(String endpoint, dynamic body) async {
    final uri = this.uri(endpoint);
    final resp = await http.post(uri.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: body);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return resp.body;
  }

  Future<void> postOpDaySaveIngredientsQty(List<IngredientUpdate> updates) {
    final body = jsonEncode({'updates': updates});
    return this._postJson('/op_days/save_ingredients_qty', body);
  }

  Future<void> postOpDaySavePrepQty(List<PrepUpdate> updates) {
    final body = jsonEncode({'updates': updates});
    return this._postJson('/op_days/save_prep_qty', body);
  }

  Future<void> postProcurementItemUpdates(List<ProcurementUpdate> updates) {
    final body = jsonEncode({'updates': updates});
    return this._postJson('/procurement/update_items', body);
  }

  Future<void> postOrderItemUpdates(List<OrderItemUpdate> updates) {
    final body = jsonEncode({'updates': updates});
    return this._postJson('/orders/update_items', body);
  }

  Future<void> postOrderUpdateState(Order order) {
    final orderState = order.orderState();
    if (orderState.nextAction != null) {
      final body = jsonEncode({'state_action': orderState.nextAction});
      return this._postJson('/orders/${order.id}/update_state', body);
    } else {
      return Future.value(null);
    }
  }

  Future<dynamic> postVerifyUser(int kitchenId, String token) {
    final body = jsonEncode({'kitchen_id': kitchenId, 'token': token});
    return this._postJson('/users/verify_kitchen', body);
  }
}
