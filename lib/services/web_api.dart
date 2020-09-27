import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kitchen/api/new_input.dart';
import '../api/input_update.dart';
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
    final uri = Uri(
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

  Future<String> fetchOpDayJson(int kitchenId) => this._fetchJson('/op_days',
      queryParameters: {"kitchen_id": kitchenId.toString()});
  Future<String> fetchOrdersJson(int kitchenId) => this._fetchJson('/orders',
      queryParameters: {"kitchen_id": kitchenId.toString()});
  Future<String> fetchProcurementJson(int kitchenId) =>
      this._fetchJson('/procurement',
          queryParameters: {"kitchen_id": kitchenId.toString()});

  Future<dynamic> _postJson(String endpoint, dynamic body) async {
    final uri = this.uri(endpoint);
    final resp = await http.post(uri.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: body);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw (resp.body);
    }

    return resp.body;
  }

  Future<void> postOpDaySaveInputsQty(List<InputUpdate> updates) {
    final body = jsonEncode({'updates': updates});
    return this._postJson('/op_days/save_inputs_qty', body);
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

  Future<dynamic> postAddInputs(int kitchenId, List<NewInput> newInputs) {
    final body = jsonEncode({'kitchen_id': kitchenId, 'inputs': newInputs});
    return this._postJson('/op_days/add_inputs', body);
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
