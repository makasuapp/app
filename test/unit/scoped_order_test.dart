import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';
import 'package:kitchen/models/order_item.dart';
import 'package:kitchen/models/order.dart';
import 'package:kitchen/models/customer.dart';
import 'package:kitchen/api/order_item_update.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  test('load orders API', () async {
    final scopedOrder = locator<ScopedOrder>();
    await scopedOrder.loadOrders();

    expect(scopedOrder.orders.length, greaterThan(0));
    expect(scopedOrder.recipesMap.values.length, greaterThan(0));
    expect(scopedOrder.recipeStepsMap.values.length, greaterThan(0));
  }, skip: 'run manually for sanity checks');

  //TODO: write tests for moveToNextState

  group('markItemsDoneTime', () {
    var id = 0;
    final sec = 11593819126;
    final api = MockApi();

    OrderItem mkOrderItem(int doneAtSec) {
      id += 1;
      return OrderItem(id, 1, 100, 2, doneAtSec: doneAtSec);
    }

    Order mkOrder(List<OrderItem> items) {
      id += 1;
      return Order(id, "new", "delivery", sec, items, Customer(1));
    }

    group('clearing doneAt', () {
      final oi1 = mkOrderItem(sec);
      final oi2 = mkOrderItem(sec);
      test('makes API call on same orders items', () {
        final order = mkOrder([oi1, oi2]);
        final scopedOrder = ScopedOrder(api: api, orders: [order]);

        scopedOrder.markItemsDoneTime({oi1.id: oi1, oi2.id: oi2}, null);
        List<OrderItemUpdate> captured =
            verify(api.postOrderItemUpdates(captureAny)).captured.first;
        expect(captured.length, equals(2));
        expect(captured.first.clearDoneAt, isTrue);
        expect(captured.last.clearDoneAt, isTrue);

        final items = scopedOrder.orders.first.items;
        expect(items.first.doneAtSec, equals(null));
        expect(items.last.doneAtSec, equals(null));
      });

      test("makes API call across different orders' items", () {
        final o1 = mkOrder([oi1]);
        final o2 = mkOrder([oi2]);
        final scopedOrder = ScopedOrder(api: api, orders: [o1, o2]);

        scopedOrder.markItemsDoneTime({oi1.id: oi1, oi2.id: oi2}, null);
        List<OrderItemUpdate> captured =
            verify(api.postOrderItemUpdates(captureAny)).captured.first;
        expect(captured.length, equals(2));
        expect(captured.first.clearDoneAt, isTrue);
        expect(captured.last.clearDoneAt, isTrue);

        final orders = scopedOrder.orders;
        expect(orders.first.items.first.doneAtSec, equals(null));
        expect(orders.last.items.first.doneAtSec, equals(null));
      });
    });

    group('setting doneAt', () {
      final oi1 = mkOrderItem(null);
      final oi2 = mkOrderItem(sec - 10);
      test('makes API call on same orders items', () {
        final order = mkOrder([oi1, oi2]);
        final scopedOrder = ScopedOrder(api: api, orders: [order]);

        scopedOrder.markItemsDoneTime({oi1.id: oi1, oi2.id: oi2},
            DateTime.fromMillisecondsSinceEpoch(sec * 1000));
        List<OrderItemUpdate> captured =
            verify(api.postOrderItemUpdates(captureAny)).captured.first;
        expect(captured.length, equals(2));
        expect(captured.first.doneAtSec, sec);
        expect(captured.last.doneAtSec, sec);

        final items = scopedOrder.orders.first.items;
        expect(items.first.doneAtSec, equals(sec));
        expect(items.last.doneAtSec, equals(sec));
      });

      test("makes API call across different orders' items", () {
        final o1 = mkOrder([oi1]);
        final o2 = mkOrder([oi2]);
        final scopedOrder = ScopedOrder(api: api, orders: [o1, o2]);

        scopedOrder.markItemsDoneTime({oi1.id: oi1, oi2.id: oi2},
            DateTime.fromMillisecondsSinceEpoch(sec * 1000));
        List<OrderItemUpdate> captured =
            verify(api.postOrderItemUpdates(captureAny)).captured.first;
        expect(captured.length, equals(2));
        expect(captured.first.doneAtSec, sec);
        expect(captured.last.doneAtSec, sec);

        final orders = scopedOrder.orders;
        expect(orders.first.items.first.doneAtSec, equals(sec));
        expect(orders.last.items.first.doneAtSec, equals(sec));
      });
    });
  });
}
