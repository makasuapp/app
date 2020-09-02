import 'dart:convert';
import 'package:meta/meta.dart';
import '../services/web_api.dart';
import '../api/procurement_update.dart';
import '../models/procurement_order.dart';
import '../models/procurement_item.dart';
import 'scoped_lookup.dart';
import 'scoped_api_model.dart';
import '../services/logger.dart';

const RETRY_WAIT_SECONDS = 2;
const NUM_RETRIES = 3;

class ScopedProcurement extends ScopedApiModel {
  List<ProcurementOrder> orders;

  @visibleForTesting
  List<ProcurementUpdate> unsavedUpdates;
  @visibleForTesting
  int retryCount = 0;

  ScopedProcurement(
      {List<ProcurementOrder> orders,
      WebApi api,
      List<ProcurementUpdate> unsavedUpdates,
      ScopedLookup scopedLookup})
      : super(api: api) {
    this.unsavedUpdates = unsavedUpdates ?? [];
    this.orders = orders ?? List();
  }

  Future<void> loadOrders(int kitchenId, {forceLoad = false}) async {
    loadData(() async {
      final orders = await _fetchOrders(kitchenId);
      this.orders = orders;
    }, forceLoad: forceLoad);
  }

  @visibleForTesting
  int compareOrders(ProcurementOrder a, ProcurementOrder b) {
    return a.forDateSec - b.forDateSec;
  }

  @visibleForTesting
  //gotten at the bottom, else sort by ingredient id
  int compareOrderItems(ProcurementItem a, ProcurementItem b) {
    if (a.gotQty == null && b.gotQty == null) {
      return a.ingredientId - b.ingredientId;
    } else if (a.gotQty == null) {
      return -1;
    } else {
      return 1;
    }
  }

  List<ProcurementOrder> _sortOrders(List<ProcurementOrder> orders) {
    orders.sort((a, b) => compareOrders(a, b));
    return orders.map((order) {
      order.items.sort((a, b) => compareOrderItems(a, b));
      return order;
    }).toList();
  }

  Future<List<ProcurementOrder>> _fetchOrders(int kitchenId) async {
    final procurementJson = await this.api.fetchProcurementJson(kitchenId);
    final decodedJson = json.decode(procurementJson) as List;

    final orders =
        decodedJson.map((json) => ProcurementOrder.fromJson(json)).toList();
    return _sortOrders(orders);
  }

  Future<void> updateItem(ProcurementItem item,
      {double gotQty, String gotUnit, int priceCents, String priceUnit}) async {
    final updatedItem = ProcurementItem.clone(item,
        gotQty: gotQty,
        gotUnit: gotUnit,
        priceCents: priceCents,
        priceUnit: priceUnit);
    final updatedOrders = this.orders.map((o) {
      if (o.id == item.procurementOrderId) {
        final updatedItems =
            o.items.map((i) => i.id == item.id ? updatedItem : i).toList();
        return ProcurementOrder.clone(o, updatedItems);
      } else
        return o;
    }).toList();

    this.orders = _sortOrders(updatedOrders);
    notifyListeners();

    //only make api call if something is different
    if (gotQty != item.gotQty ||
        gotUnit != item.gotUnit ||
        priceCents != item.priceCents ||
        priceUnit != item.priceUnit) {
      this.unsavedUpdates.add(ProcurementUpdate(item.id,
          gotQty: gotQty,
          gotUnit: gotUnit,
          priceCents: priceCents,
          priceUnit: priceUnit));
      await _saveUnsavedQty();
    }
  }

  Future<void> _saveUnsavedQty() async {
    try {
      final savingUpdatesMap = Map<String, ProcurementUpdate>.fromIterable(
          this.unsavedUpdates,
          key: (u) => u.id(),
          value: (u) => u);
      if (savingUpdatesMap.keys.length > 0) {
        await this
            .api
            .postProcurementItemUpdates(savingUpdatesMap.values.toList());
      }

      this.retryCount = 0;
      this.unsavedUpdates = this
          .unsavedUpdates
          .where((u) => !savingUpdatesMap.containsKey(u.id()))
          .toList();
    } catch (err) {
      Logger.error(err);
      _retryLater();
    }
  }

  Future<void> _retryLater() async {
    final retryCount = this.retryCount + 1;
    this.retryCount = retryCount;

    final waitTime = RETRY_WAIT_SECONDS * retryCount;
    await Future.delayed(Duration(seconds: waitTime));

    if (retryCount <= NUM_RETRIES) {
      _saveUnsavedQty();
    } else {
      Logger.error("hit max retries in scoped_day_prep");
    }
  }
}
