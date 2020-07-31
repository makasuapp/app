import 'dart:convert';
import '../services/web_api.dart';
import '../service_locator.dart';
import '../models/procurement_order.dart';
import './scoped_data.dart';
import './scoped_data_model.dart';

class ScopedProcurement extends ScopedDataModel {
  List<ProcurementOrder> orders;
  bool isLoading = false;
  WebApi api;
  static ScopedData _scopedData = locator<ScopedData>();

  DateTime _lastLoaded;

  ScopedProcurement(
      {List<ProcurementOrder> orders, WebApi api, ScopedData scopedData}) {
    this.api = api ?? locator<WebApi>();
    this.orders = orders ?? List();

    if (scopedData != null) {
      _scopedData = scopedData;
    }
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

      final orders = await _fetchOrders();
      this.orders = orders;

      this.isLoading = false;
      this._lastLoaded = now;

      notifyListeners();
    }
  }

  Future<List<ProcurementOrder>> _fetchOrders() async {
    final procurementJson = await this.api.fetchProcurementJson();
    final decodedJson = json.decode(procurementJson) as List;

    return decodedJson.map((json) => ProcurementOrder.fromJson(json)).toList();
  }
}
