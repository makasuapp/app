// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'op_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpDay _$OpDayFromJson(Map<String, dynamic> json) {
  return OpDay(
    json['date_sec'] as int,
    (json['inputs'] as List)
        .map((e) => DayInput.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['prep'] as List)
        .map((e) => DayPrep.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['predicted_orders'] as List)
        .map((e) => PredictedOrder.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['recipes'] as List)
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['ingredients'] as List)
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['recipe_steps'] as List)
        .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$OpDayToJson(OpDay instance) => <String, dynamic>{
      'date_sec': instance.dateSec,
      'inputs': instance.inputs,
      'prep': instance.prep,
      'predicted_orders': instance.predictedOrders,
      'recipes': instance.recipes,
      'ingredients': instance.ingredients,
      'recipe_steps': instance.recipeSteps,
    };
