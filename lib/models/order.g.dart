// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    json['id'] as int,
    json['state'] as String,
    json['order_type'] as String,
    json['created_at'] as int,
    (json['items'] as List)
        .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    Customer.fromJson(json['customer'] as Map<String, dynamic>),
    json['order_id'] as String,
    integrationType: json['integration_type'] as String,
    forSec: json['for_time'] as int,
    comment: json['comment'] as String,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'order_id': instance.externalId,
      'state': instance.state,
      'order_type': instance.orderType,
      'created_at': instance.createdAtSec,
      'for_time': instance.forSec,
      'integration_type': instance.integrationType,
      'comment': instance.comment,
      'items': instance.items,
      'customer': instance.customer,
    };
