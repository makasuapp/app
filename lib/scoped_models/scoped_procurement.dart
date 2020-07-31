import 'dart:convert';
import '../services/web_api.dart';
import '../models/procurement_order.dart';
import 'scoped_lookup.dart';
import 'scoped_api_model.dart';

class ScopedProcurement extends ScopedApiModel {
  List<ProcurementOrder> orders;

  ScopedProcurement(
      {List<ProcurementOrder> orders, WebApi api, ScopedLookup scopedLookup})
      : super(api: api) {
    this.orders = orders ?? List();
  }

  Future<void> loadOrders({forceLoad = false}) async {
    loadData(() async {
      final orders = await _fetchOrders();
      this.orders = orders;
    }, forceLoad: forceLoad);
  }

  Future<List<ProcurementOrder>> _fetchOrders() async {
    final procurementJson = await this.api.fetchProcurementJson();
    final decodedJson = json.decode(procurementJson) as List;

    return decodedJson.map((json) => ProcurementOrder.fromJson(json)).toList();
  }
}
