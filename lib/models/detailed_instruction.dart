import 'package:json_annotation/json_annotation.dart';

part 'detailed_instruction.g.dart';

@JsonSerializable()
class DetailedInstruction {
  final int id;
  final String instruction;

  DetailedInstruction(this.id, this.instruction);

  factory DetailedInstruction.fromJson(Map<String, dynamic> json) =>
      _$DetailedInstructionFromJson(json);
}
