// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
    json['id'] as int,
    json['recipe_id'] as int,
    json['price_cents'] as int,
    json['quantity'] as int,
    startedAtSec: json['started_at'] as int,
    doneAtSec: json['done_at'] as int,
    comment: json['comment'] as String,
  );
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'recipe_id': instance.recipeId,
      'price_cents': instance.priceCents,
      'quantity': instance.quantity,
      'started_at': instance.startedAtSec,
      'done_at': instance.doneAtSec,
      'comment': instance.comment,
    };
