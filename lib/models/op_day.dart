import 'package:json_annotation/json_annotation.dart';
import 'predicted_order.dart';
import 'recipe.dart';
import 'recipe_step.dart';
import 'ingredient.dart';
import 'day_input.dart';
import './day_prep.dart';

part 'op_day.g.dart';

@JsonSerializable()
class OpDay {
  @JsonKey(name: "date_sec")
  final int dateSec;
  final List<DayInput> inputs;
  final List<DayPrep> prep;
  @JsonKey(name: "predicted_orders")
  final List<PredictedOrder> predictedOrders;
  final List<Recipe> recipes;
  final List<Ingredient> ingredients;
  @JsonKey(name: "recipe_steps")
  final List<RecipeStep> recipeSteps;

  OpDay(this.dateSec, this.inputs, this.prep, this.predictedOrders,
      this.recipes, this.ingredients, this.recipeSteps);

  factory OpDay.fromJson(Map<String, dynamic> json) => _$OpDayFromJson(json);
  Map<String, dynamic> toJson() => _$OpDayToJson(this);

  DateTime date() {
    return DateTime.fromMillisecondsSinceEpoch(this.dateSec * 1000);
  }
}
