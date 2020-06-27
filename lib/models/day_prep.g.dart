// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_prep.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayPrep _$DayPrepFromJson(Map<String, dynamic> json) {
  return DayPrep(
    json['id'] as int,
    (json['expected_qty'] as num).toDouble(),
    RecipeStep.fromJson(json['recipe_step'] as Map<String, dynamic>),
    madeQty: (json['made_qty'] as num)?.toDouble(),
    qtyUpdatedAtSec: json['qty_updated_at'] as int,
  );
}

Map<String, dynamic> _$DayPrepToJson(DayPrep instance) => <String, dynamic>{
      'id': instance.id,
      'expected_qty': instance.expectedQty,
      'made_qty': instance.madeQty,
      'qty_updated_at': instance.qtyUpdatedAtSec,
      'recipe_step': instance.recipeStep,
    };
