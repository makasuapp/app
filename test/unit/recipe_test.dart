import 'dart:convert';
import 'package:test/test.dart';
import 'package:kitchen/models/recipe.dart';

void main() {
  test('recipe from JSON', () {
    const recipeJSON = '{"id":18,"name":"Mouth Watering Chicken","publish":true,"output_qty":2.0,"prep_steps":[{"id":41,"number":1,"instruction":"Dry brine chicken overnight","min_before_sec":28800,"tools":[],"detailed_instructions":[{"id":1,"instruction":"Rub salt all over chicken over and under the skin. Store uncovered in a fridge"}],"inputs":[{"id":84,"inputable_type":"Ingredient","inputable_id":14,"quantity":1.0},{"id":85,"inputable_type":"Ingredient","inputable_id":1,"quantity":1.0}]},{"id":42,"number":2,"instruction":"Submerge whole chicken in water with dried peppers, sichuan peppercorn, green onion chunks, ginger chunks, lots of salt. Squeeze the green onions and ginger to get juices into it.","tools":[{"id":3,"name":"Stock Pot"}],"detailed_instructions":[],"inputs":[{"id":86,"inputable_type":"RecipeStep","inputable_id":41,"quantity":1.0},{"id":87,"inputable_type":"Ingredient","inputable_id":16,"quantity":1.0},{"id":88,"inputable_type":"Ingredient","inputable_id":9,"quantity":3.0},{"id":89,"inputable_type":"Ingredient","inputable_id":8,"quantity":10.0},{"id":90,"inputable_type":"Ingredient","inputable_id":11,"unit":"grams","quantity":4.0},{"id":91,"inputable_type":"Ingredient","inputable_id":13,"quantity":1.0},{"id":92,"inputable_type":"Ingredient","inputable_id":1,"unit":"tablespoons","quantity":5.0}]},{"id":43,"number":3,"duration_sec":1200,"instruction":"Cook on low heat for 20 minutes","tools":[{"id":1,"name":"Stove"}],"detailed_instructions":[],"inputs":[{"id":93,"inputable_type":"RecipeStep","inputable_id":42,"quantity":1.0}]},{"id":44,"number":4,"instruction":"Dunk in ice bath to stop cooking","tools":[],"detailed_instructions":[],"inputs":[{"id":94,"inputable_type":"RecipeStep","inputable_id":43,"quantity":1.0},{"id":95,"inputable_type":"Ingredient","inputable_id":15,"quantity":1.0},{"id":96,"inputable_type":"Ingredient","inputable_id":16,"quantity":1.0}]}],"cook_steps":[{"id":45,"number":1,"instruction":"Cut chicken into cubes","tools":[{"id":5,"name":"Chef Knife"}],"detailed_instructions":[],"inputs":[{"id":97,"inputable_type":"RecipeStep","inputable_id":44,"quantity":1.0}]},{"id":46,"number":2,"instruction":"Drizzle on sauce and green onions as garnish","tools":[],"detailed_instructions":[],"inputs":[{"id":98,"inputable_type":"RecipeStep","inputable_id":45,"quantity":1.0},{"id":99,"inputable_type":"Recipe","inputable_id":17,"quantity":1.0},{"id":100,"inputable_type":"Recipe","inputable_id":14,"unit":"grams","quantity":100.0}]}]}';

    final recipeMap = json.decode(recipeJSON) as Map<String, dynamic>;
    expect(recipeMap['id'], equals(18));

    final recipe = Recipe.fromJson(recipeMap);
    expect(recipe.id, equals(18));
    expect(recipe.outputQty, equals(recipeMap['output_qty']));
    expect(recipe.unit, equals(null));

    final prepStep = recipe.prepSteps[0];
    expect(prepStep.id, equals(41));
    expect(prepStep.minBeforeSec, equals(28800));
    expect(prepStep.maxBeforeSec, equals(null));
    expect(prepStep.detailedInstructions[0].id, equals(1));

    final input = prepStep.inputs[0];
    expect(input.id, equals(84));
    expect(input.inputableType, equals("Ingredient"));
    expect(input.inputableId, equals(14));
  });

  test('recipe API', () async {
    final recipes = await Recipe.fetchAll();
    final recipe = recipes[0];
    expect(recipe.name, isNotNull);
  }, skip: 'run manually for sanity checks');
}