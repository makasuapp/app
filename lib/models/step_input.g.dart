// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepInput _$StepInputFromJson(Map<String, dynamic> json) {
  return StepInput(
    json['id'] as int,
    json['name'] as String,
    json['inputable_id'] as int,
    json['inputable_type'] as String,
    unit: json['unit'] as String,
    quantity: (json['quantity'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$StepInputToJson(StepInput instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'inputable_type': instance.inputableType,
      'inputable_id': instance.inputableId,
      'unit': instance.unit,
      'quantity': instance.quantity,
    };
