// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayIngredient _$DayIngredientFromJson(Map<String, dynamic> json) {
  return DayIngredient(
    json['id'] as int,
    json['name'] as String,
    (json['expected_qty'] as num).toDouble(),
    hadQty: (json['had_qty'] as num)?.toDouble(),
    unit: json['unit'] as String,
  );
}

Map<String, dynamic> _$DayIngredientToJson(DayIngredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'expected_qty': instance.expectedQty,
      'had_qty': instance.hadQty,
      'unit': instance.unit,
    };
