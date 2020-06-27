// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'op_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpDay _$OpDayFromJson(Map<String, dynamic> json) {
  return OpDay(
    (json['ingredients'] as List)
        .map((e) => DayIngredient.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['prep'] as List)
        .map((e) => DayPrep.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['recipes'] as List)
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$OpDayToJson(OpDay instance) => <String, dynamic>{
      'ingredients': instance.ingredients,
      'prep': instance.prep,
      'recipes': instance.recipes,
    };
