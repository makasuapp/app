import 'package:json_annotation/json_annotation.dart';
import './step_input.dart';
import './tool.dart';
import './detailed_instruction.dart';

part 'recipe_step.g.dart';

@JsonSerializable()
class RecipeStep {
  final int id;
  @JsonKey(name: "recipe_id")
  final int recipeId;
  @JsonKey(name: "step_type")
  final String stepType;
  final int number;
  final String instruction;
  @JsonKey(name: "duration_sec", nullable: true)
  final int durationSec;
  @JsonKey(name: "max_before_sec", nullable: true)
  final int maxBeforeSec;
  @JsonKey(name: "min_before_sec", nullable: true)
  final int minBeforeSec;

  List<Tool> tools;
  @JsonKey(name: "detailed_instructions")
  List<DetailedInstruction> detailedInstructions;
  @JsonKey(name: "inputs")
  List<StepInput> inputs;

  RecipeStep(this.id, this.recipeId, this.stepType, this.number,
      this.instruction, this.tools, this.detailedInstructions, this.inputs,
      {this.durationSec, this.maxBeforeSec, this.minBeforeSec});

  factory RecipeStep.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepFromJson(json);
}
