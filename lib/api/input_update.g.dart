// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputUpdate _$InputUpdateFromJson(Map<String, dynamic> json) {
  return InputUpdate(
    json['id'] as int,
    (json['had_qty'] as num).toDouble(),
    json['time_sec'] as int,
  );
}

Map<String, dynamic> _$InputUpdateToJson(InputUpdate instance) =>
    <String, dynamic>{
      'id': instance.dayInputId,
      'had_qty': instance.hadQty,
      'time_sec': instance.timeSec,
    };
