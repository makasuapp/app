// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    json['id'] as int,
    json['name'] as String,
    volumeWeightRatio: (json['volume_weight_ratio'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'volume_weight_ratio': instance.volumeWeightRatio,
    };
