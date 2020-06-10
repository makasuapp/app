// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    json['id'] as int,
    json['name'] as String,
    (json['prep_steps'] as List)
        .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['cook_steps'] as List)
        .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
        .toList(),
    outputQuantity: (json['output_quantity'] as num)?.toDouble(),
    unit: json['unit'] as String,
    publish: json['publish'] as bool,
  );
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'publish': instance.publish,
      'output_quantity': instance.outputQuantity,
      'unit': instance.unit,
      'prep_steps': instance.prepSteps,
      'cook_steps': instance.cookSteps,
    };
