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
    print(scopedOrder.recipesMap);
    print(scopedOrder.recipeStepsMap);
  }, skip: 'run manually for sanity checks');
}
