// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewInput _$NewInputFromJson(Map<String, dynamic> json) {
  return NewInput(
    json['inputable_type'] as String,
    json['inputable_id'] as int,
    (json['qty'] as num).toDouble(),
    json['unit'] as String,
  );
}

Map<String, dynamic> _$NewInputToJson(NewInput instance) => <String, dynamic>{
      'inputable_type': instance.inputableType,
      'inputable_id': instance.inputableId,
      'qty': instance.qty,
      'unit': instance.unit,
    };
