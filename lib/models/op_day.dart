import 'package:json_annotation/json_annotation.dart';
import './day_ingredient.dart';
import './day_prep.dart';

part 'op_day.g.dart';

@JsonSerializable()
class OpDay {
  final List<DayIngredient> ingredients;
  final List<DayPrep> prep;

  OpDay(this.ingredients, this.prep);

  factory OpDay.fromJson(Map<String, dynamic> json) => _$OpDayFromJson(json);
  Map<String, dynamic> toJson() => _$OpDayToJson(this);
}
