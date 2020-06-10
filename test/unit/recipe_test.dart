import 'dart:convert';
import 'package:test/test.dart';
import 'package:kitchen/models/recipe.dart';

void main() {
  test('recipe from JSON', () {
    const recipeJSON = '{"id":9,"name":"Mouth Watering Chicken","publish":true,"output_quantity":2.0,"prep_steps":[{"id":18,"number":1,"instruction":"Dry brine chicken overnight","min_before_sec":28800,"tools":[],"detailed_instructions":[{"id":1,"instruction":"Rub salt all over chicken over and under the skin. Store uncovered in a fridge"}],"inputs":[{"id":34,"inputable_type":"Ingredient","inputable_id":14,"quantity":1.0},{"id":35,"inputable_type":"Ingredient","inputable_id":1,"quantity":1.0}]},{"id":19,"number":2,"instruction":"Submerge whole chicken in water with dried peppers, sichuan peppercorn, green onion chunks, ginger chunks, lots of salt. Squeeze the green onions and ginger to get juices into it.","tools":[{"id":3,"name":"Stock Pot"}],"detailed_instructions":[],"inputs":[{"id":36,"inputable_type":"RecipeStep","inputable_id":18,"quantity":1.0},{"id":37,"inputable_type":"Ingredient","inputable_id":16,"quantity":1.0},{"id":38,"inputable_type":"Ingredient","inputable_id":9,"quantity":3.0},{"id":39,"inputable_type":"Ingredient","inputable_id":8,"quantity":10.0},{"id":40,"inputable_type":"Ingredient","inputable_id":11,"unit":"cm","quantity":4.0},{"id":41,"inputable_type":"Ingredient","inputable_id":13,"quantity":1.0},{"id":42,"inputable_type":"Ingredient","inputable_id":1,"unit":"tbsp","quantity":5.0}]},{"id":20,"number":3,"duration_sec":1200,"instruction":"Cook on low heat for 20 minutes","tools":[{"id":1,"name":"Stove"}],"detailed_instructions":[],"inputs":[{"id":43,"inputable_type":"RecipeStep","inputable_id":19,"quantity":1.0}]},{"id":21,"number":4,"instruction":"Dunk in ice bath to stop cooking","tools":[],"detailed_instructions":[],"inputs":[{"id":44,"inputable_type":"RecipeStep","inputable_id":20,"quantity":1.0},{"id":45,"inputable_type":"Ingredient","inputable_id":15,"quantity":1.0},{"id":46,"inputable_type":"Ingredient","inputable_id":16,"quantity":1.0}]}],"cook_steps":[{"id":22,"number":1,"instruction":"Cut chicken into cubes","tools":[{"id":5,"name":"Chef Knife"}],"detailed_instructions":[],"inputs":[{"id":47,"inputable_type":"RecipeStep","inputable_id":21,"quantity":1.0}]},{"id":23,"number":2,"instruction":"Drizzle on sauce and green onions as garnish","tools":[],"detailed_instructions":[],"inputs":[{"id":48,"inputable_type":"RecipeStep","inputable_id":22,"quantity":1.0},{"id":49,"inputable_type":"Recipe","inputable_id":8,"quantity":1.0},{"id":50,"inputable_type":"Recipe","inputable_id":5,"quantity":1.0}]}]}';

    final recipeMap = json.decode(recipeJSON) as Map<String, dynamic>;
    expect(recipeMap['id'], equals(9));

    final recipe = Recipe.fromJson(recipeMap);
    expect(recipe.id, equals(9));
    expect(recipe.outputQuantity, equals(recipeMap['output_quantity']));
    expect(recipe.unit, equals(null));

    final prepStep = recipe.prepSteps[0];
    expect(prepStep.id, equals(18));
    expect(prepStep.minBeforeSec, equals(28800));
    expect(prepStep.maxBeforeSec, equals(null));
    expect(prepStep.detailedInstructions[0].id, equals(1));

    final input = prepStep.inputs[0];
    expect(input.id, equals(34));
    expect(input.inputableType, equals("Ingredient"));
    expect(input.inputableId, equals(14));
  });

  test('recipe API', () async {
    final recipes = await Recipe.fetchAll();
    final recipe = recipes[0];
    expect(recipe.name, isNotNull);
  }, skip: 'just run manually for sanity checks');
}