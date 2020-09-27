import 'package:json_annotation/json_annotation.dart';

part 'new_input.g.dart';

@JsonSerializable()
class NewInput {
  @JsonKey(name: "inputable_type")
  final String inputableType;
  @JsonKey(name: "inputable_id")
  int inputableId;
  double qty;
  @JsonKey(name: "unit", nullable: true)
  String unit;

  NewInput(this.inputableType, {this.inputableId, this.qty, this.unit});

  factory NewInput.fromJson(Map<String, dynamic> json) =>
      _$NewInputFromJson(json);
  Map<String, dynamic> toJson() => _$NewInputToJson(this);
}
