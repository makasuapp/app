// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadOrdersResponse _$LoadOrdersResponseFromJson(Map<String, dynamic> json) {
  return LoadOrdersResponse(
    (json['recipes'] as List)
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['recipe_steps'] as List)
        .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['orders'] as List)
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$LoadOrdersResponseToJson(LoadOrdersResponse instance) =>
    <String, dynamic>{
      'recipes': instance.recipes,
      'recipe_steps': instance.recipeSteps,
      'orders': instance.orders,
    };
