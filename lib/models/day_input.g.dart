// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayInput _$DayInputFromJson(Map<String, dynamic> json) {
  return DayInput(
    json['id'] as int,
    json['inputable_id'] as int,
    json['inputable_type'] as String,
    (json['expected_qty'] as num).toDouble(),
    hadQty: (json['had_qty'] as num)?.toDouble(),
    qtyUpdatedAtSec: json['qty_updated_at'] as int,
    unit: json['unit'] as String,
  );
}

Map<String, dynamic> _$DayInputToJson(DayInput instance) => <String, dynamic>{
      'id': instance.id,
      'inputable_id': instance.inputableId,
      'inputable_type': instance.inputableType,
      'expected_qty': instance.expectedQty,
      'had_qty': instance.hadQty,
      'qty_updated_at': instance.qtyUpdatedAtSec,
      'unit': instance.unit,
    };
