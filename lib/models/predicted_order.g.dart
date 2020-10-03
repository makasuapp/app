// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predicted_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictedOrder _$PredictedOrderFromJson(Map<String, dynamic> json) {
  return PredictedOrder(json['id'] as int, json['recipe_id'] as int,
      json['quantity'] as int, json['date_sec'] as int);
}

Map<String, dynamic> _$PredictedOrderToJson(PredictedOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipe_id': instance.recipeId,
      'quantity': instance.quantity,
      'date_sec': instance.dateSec,
    };
