// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcurementOrder _$ProcurementOrderFromJson(Map<String, dynamic> json) {
  return ProcurementOrder(
    json['id'] as int,
    json['for_date'] as int,
    json['order_type'] as String,
    json['vendor_name'] as String,
    (json['items'] as List)
        .map((e) => ProcurementItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ProcurementOrderToJson(ProcurementOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'for_date': instance.forDateSec,
      'order_type': instance.orderType,
      'vendor_name': instance.vendorName,
      'items': instance.items,
    };
