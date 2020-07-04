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
    forSec: json['for_time'] as int,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'order_type': instance.orderType,
      'created_at': instance.createdAtSec,
      'for_time': instance.forSec,
      'items': instance.items,
      'customer': instance.customer,
    };
