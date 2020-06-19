// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientUpdate _$IngredientUpdateFromJson(Map<String, dynamic> json) {
  return IngredientUpdate(
    json['id'] as int,
    (json['had_qty'] as num).toDouble(),
    json['time_sec'] as int,
  );
}

Map<String, dynamic> _$IngredientUpdateToJson(IngredientUpdate instance) =>
    <String, dynamic>{
      'id': instance.dayIngredientId,
      'had_qty': instance.hadQty,
      'time_sec': instance.timeSec,
    };
