// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemUpdate _$OrderItemUpdateFromJson(Map<String, dynamic> json) {
  return OrderItemUpdate(
    json['id'] as int,
    json['time_sec'] as int,
    doneAtSec: json['done_at'] as int,
    clearDoneAt: json['clear_done_at'] as bool,
  );
}

Map<String, dynamic> _$OrderItemUpdateToJson(OrderItemUpdate instance) =>
    <String, dynamic>{
      'id': instance.orderItemId,
      'done_at': instance.doneAtSec,
      'clear_done_at': instance.clearDoneAt,
      'time_sec': instance.timeSec,
    };
