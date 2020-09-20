// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    json['id'] as int,
    json['name'] as String,
    stepIds: (json['step_ids'] as List)?.map((e) => e as int)?.toList(),
    outputQty: (json['output_qty'] as num)?.toDouble(),
    unit: json['unit'] as String,
    volumeWeightRatio: (json['volume_weight_ratio'] as num)?.toDouble(),
    publish: json['publish'] as bool,
  );
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'publish': instance.publish,
      'output_qty': instance.outputQty,
      'unit': instance.unit,
      'volume_weight_ratio': instance.volumeWeightRatio,
      'step_ids': instance.stepIds,
    };
