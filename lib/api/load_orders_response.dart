import 'package:json_annotation/json_annotation.dart';
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

  LoadOrdersResponse(this.recipes, this.recipeSteps, this.orders);

  factory LoadOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$LoadOrdersResponseFromJson(json);
}
