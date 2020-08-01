// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procurement_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcurementUpdate _$ProcurementUpdateFromJson(Map<String, dynamic> json) {
  return ProcurementUpdate(
    json['id'] as int,
    gotQty: (json['got_qty'] as num)?.toDouble(),
    gotUnit: json['got_unit'] as String,
    priceCents: json['price_cents'] as int,
    priceUnit: json['price_unit'] as String,
  );
}

Map<String, dynamic> _$ProcurementUpdateToJson(ProcurementUpdate instance) =>
    <String, dynamic>{
      'id': instance.procurementItemId,
      'got_qty': instance.gotQty,
      'got_unit': instance.gotUnit,
      'price_cents': instance.priceCents,
      'price_unit': instance.priceUnit,
    };
