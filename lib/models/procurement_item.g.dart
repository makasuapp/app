// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcurementItem _$ProcurementItemFromJson(Map<String, dynamic> json) {
  return ProcurementItem(
    json['id'] as int,
    json['ingredient_id'] as int,
    json['procurement_order_id'] as int,
    (json['quantity'] as num).toDouble(),
    unit: json['unit'] as String,
    gotQty: (json['got_qty'] as num)?.toDouble(),
    gotUnit: json['got_unit'] as String,
    priceCents: json['price_cents'] as int,
  );
}

Map<String, dynamic> _$ProcurementItemToJson(ProcurementItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ingredient_id': instance.ingredientId,
      'procurement_order_id': instance.procurementOrderId,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'got_qty': instance.gotQty,
      'got_unit': instance.gotUnit,
      'price_cents': instance.priceCents,
    };
