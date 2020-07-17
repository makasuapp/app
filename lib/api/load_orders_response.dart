import 'package:json_annotation/json_annotation.dart';
import '../models/ingredient.dart';
import '../models/order.dart';
import '../models/recipe.dart';
import '../models/recipe_step.dart';

part 'load_orders_response.g.dart';

@JsonSerializable()
class LoadOrdersResponse {
  final List<Recipe> recipes;
  @JsonKey(name: "recipe_steps")
  final List<RecipeStep> recipeSteps;
  final List<Order> orders;
  final List<Ingredient> ingredients;

  LoadOrdersResponse(
      this.recipes, this.recipeSteps, this.orders, this.ingredients);

  factory LoadOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$LoadOrdersResponseFromJson(json);
}
