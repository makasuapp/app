// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prep_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrepUpdate _$PrepUpdateFromJson(Map<String, dynamic> json) {
  return PrepUpdate(
    json['id'] as int,
    (json['made_qty'] as num).toDouble(),
    json['time_sec'] as int,
  );
}

Map<String, dynamic> _$PrepUpdateToJson(PrepUpdate instance) =>
    <String, dynamic>{
      'id': instance.dayPrepId,
      'made_qty': instance.madeQty,
      'time_sec': instance.timeSec,
    };
