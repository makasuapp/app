// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeStep _$RecipeStepFromJson(Map<String, dynamic> json) {
  return RecipeStep(
    json['id'] as int,
    json['number'] as int,
    json['instruction'] as String,
    (json['tools'] as List)
        .map((e) => Tool.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['detailed_instructions'] as List)
        .map((e) => DetailedInstruction.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['inputs'] as List)
        .map((e) => StepInput.fromJson(e as Map<String, dynamic>))
        .toList(),
    durationSec: json['duration_sec'] as int,
    maxBeforeSec: json['max_before_sec'] as int,
    minBeforeSec: json['min_before_sec'] as int,
  );
}

Map<String, dynamic> _$RecipeStepToJson(RecipeStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'instruction': instance.instruction,
      'duration_sec': instance.durationSec,
      'max_before_sec': instance.maxBeforeSec,
      'min_before_sec': instance.minBeforeSec,
      'tools': instance.tools,
      'detailed_instructions': instance.detailedInstructions,
      'inputs': instance.inputs,
    };
