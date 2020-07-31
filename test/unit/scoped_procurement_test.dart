import 'package:kitchen/scoped_models/scoped_procurement.dart';
import 'package:kitchen/services/web_api.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:kitchen/service_locator.dart';

class MockApi extends Mock implements WebApi {}

void main() {
  setupLocator();

  test('fetch orders API', () async {
    final procurement = ScopedProcurement();
    expect(procurement.orders.length, equals(0));
    await procurement.loadOrders();

    final item = procurement.orders[0].items[0];
    expect(item.ingredientId, isNotNull);
  }, skip: 'run manually for sanity checks');
}
