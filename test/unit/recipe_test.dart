import 'dart:convert';
import 'package:test/test.dart';
import 'package:kitchen/models/recipe.dart';

void main() {
  test('recipe from JSON', () {
    const recipeJSON =
        '{"id":36,"name":"Mouth Watering Chicken","publish":true,"output_qty":2.0,"step_ids":[87,88,89,90]}';

    final recipeMap = json.decode(recipeJSON) as Map<String, dynamic>;

    final recipe = Recipe.fromJson(recipeMap);
    expect(recipe.id, equals(36));
    expect(recipe.outputQty, equals(recipeMap['output_qty']));
    expect(recipe.unit, equals(null));

    final step = recipe.stepIds[0];
    expect(step, equals(87));
  });
}
