import 'dart:convert';
import 'package:test/test.dart';
import 'package:kitchen/models/ingredient.dart';

void main() {
  test('ingredient from JSON', () {
    const ingredientJSON = '{"id":16,"name":"Salt"}';

    final ingredientMap = json.decode(ingredientJSON) as Map<String, dynamic>;
    expect(ingredientMap['id'], equals(16));

    final ingredient = Ingredient.fromJson(ingredientMap);
    expect(ingredient.id, equals(16));
    expect(ingredient.name, equals("Salt"));
  });

  test('ingredient API', () async {
    final ingredients = await Ingredient.fetchAll();
    final ingredient = ingredients[0];
    expect(ingredient.name, isNotNull);
  }, skip: 'just run manually for sanity checks');
}