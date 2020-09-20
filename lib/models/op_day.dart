import 'package:json_annotation/json_annotation.dart';
import 'day_input.dart';
import './day_prep.dart';

part 'op_day.g.dart';

@JsonSerializable()
class OpDay {
  final List<DayInput> inputs;
  final List<DayPrep> prep;

  OpDay(this.inputs, this.prep);

  factory OpDay.fromJson(Map<String, dynamic> json) => _$OpDayFromJson(json);
  Map<String, dynamic> toJson() => _$OpDayToJson(this);
}
