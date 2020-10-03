import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/services/date_converter.dart';

part 'day_prep.g.dart';

@JsonSerializable()
class DayPrep {
  final int id;
  @JsonKey(name: "expected_qty")
  final double expectedQty;
  @JsonKey(name: "made_qty", nullable: true)
  double madeQty;
  @JsonKey(name: "min_needed_at")
  int minNeededAtSec;
  @JsonKey(name: "qty_updated_at", nullable: true)
  int qtyUpdatedAtSec;

  @JsonKey(name: "recipe_step_id")
  final recipeStepId;

  DayPrep(this.id, this.expectedQty, this.recipeStepId, this.minNeededAtSec,
      {this.madeQty, this.qtyUpdatedAtSec});

  factory DayPrep.fromJson(Map<String, dynamic> json) =>
      _$DayPrepFromJson(json);
  Map<String, dynamic> toJson() => _$DayPrepToJson(this);

  factory DayPrep.clone(DayPrep orig, double madeQty, DateTime updatedAt) {
    return DayPrep(
        orig.id, orig.expectedQty, orig.recipeStepId, orig.minNeededAtSec,
        madeQty: madeQty, qtyUpdatedAtSec: DateConverter.toServer(updatedAt));
  }
}
