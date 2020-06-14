import 'dart:convert';
import 'package:test/test.dart';
import 'package:kitchen/models/day_ingredient.dart';

void main() {
  test('day_ingredient from JSON', () {
    const ingredientJSON = '{"id":1,"expected_qty":4.0,"name":"Whole Chicken"}';

    final ingredientMap = json.decode(ingredientJSON) as Map<String, dynamic>;
    expect(ingredientMap['id'], equals(1));

    final ingredient = DayIngredient.fromJson(ingredientMap);
    expect(ingredient.id, equals(1));
    expect(ingredient.name, equals("Whole Chicken"));
    expect(ingredient.expectedQty, equals(4.0));
    expect(ingredient.hadQty, equals(null));
    expect(ingredient.unit, equals(null));
  });

  test('ingredient API', () async {
    final ingredients = await DayIngredient.fetchAll();
    final ingredient = ingredients[0];
    expect(ingredient.name, isNotNull);
  }, skip: 'just run manually for sanity checks');
}