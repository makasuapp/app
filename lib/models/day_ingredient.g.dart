// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayIngredient _$DayIngredientFromJson(Map<String, dynamic> json) {
  return DayIngredient(
    json['id'] as int,
    json['ingredient_id'] as int,
    (json['expected_qty'] as num).toDouble(),
    hadQty: (json['had_qty'] as num)?.toDouble(),
    qtyUpdatedAtSec: json['qty_updated_at'] as int,
    unit: json['unit'] as String,
  );
}

Map<String, dynamic> _$DayIngredientToJson(DayIngredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ingredient_id': instance.ingredientId,
      'expected_qty': instance.expectedQty,
      'had_qty': instance.hadQty,
      'qty_updated_at': instance.qtyUpdatedAtSec,
      'unit': instance.unit,
    };
