import 'dart:convert';
import 'package:test/test.dart';
import 'package:kitchen/models/ingredient_update.dart';

void main() {
  test('ingredient_update to JSON', () {
    var updates = List<IngredientUpdate>();
    updates.add(IngredientUpdate(1, 1.2, 12345));
    updates.add(IngredientUpdate(2, 1.5, 12346));

    final updatesJson = jsonEncode({'updates': updates});
    expect(
        updatesJson,
        equals(
            '{"updates":[{"id":1,"had_qty":1.2,"time_sec":12345},{"id":2,"had_qty":1.5,"time_sec":12346}]}'));
  });
}
