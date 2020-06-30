import 'package:json_annotation/json_annotation.dart';

part 'step_input.g.dart';

@JsonSerializable()
class StepInput {
  final int id;
  final String name;
  @JsonKey(name: "inputable_type")
  final String inputableType;
  @JsonKey(name: "inputable_id")
  final int inputableId;
  @JsonKey(nullable: true)
  final String unit;
  @JsonKey(nullable: true)
  final double quantity;

  //TODO: input from inputableType/Id

  StepInput(this.id, this.name, this.inputableId, this.inputableType, {this.unit, this.quantity});

  factory StepInput.fromJson(Map<String, dynamic> json) => _$StepInputFromJson(json);
}