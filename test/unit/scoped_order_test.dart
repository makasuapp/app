import 'package:kitchen/scoped_models/scoped_order.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

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
}
