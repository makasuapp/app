import 'package:json_annotation/json_annotation.dart';
import './recipe_step.dart';

part 'day_prep.g.dart';

@JsonSerializable()
class DayPrep {
  final int id;
  @JsonKey(name: "expected_qty")
  final double expectedQty;
  @JsonKey(name: "made_qty", nullable: true)
  double madeQty;
  @JsonKey(name: "qty_updated_at", nullable: true)
  int qtyUpdatedAtSec;

  @JsonKey(name: "recipe_step")
  final RecipeStep recipeStep;

  DayPrep(this.id, this.expectedQty, this.recipeStep,
      {this.madeQty, this.qtyUpdatedAtSec});

  factory DayPrep.fromJson(Map<String, dynamic> json) =>
      _$DayPrepFromJson(json);
  Map<String, dynamic> toJson() => _$DayPrepToJson(this);
}
