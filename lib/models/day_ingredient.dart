import 'package:json_annotation/json_annotation.dart';

part 'day_ingredient.g.dart';

@JsonSerializable()
class DayIngredient {
  final int id;
  @JsonKey(name: "ingredient_id")
  final int ingredientId;
  @JsonKey(name: "expected_qty")
  final double expectedQty;
  @JsonKey(name: "had_qty", nullable: true)
  double hadQty;
  @JsonKey(name: "qty_updated_at", nullable: true)
  int qtyUpdatedAtSec;
  @JsonKey(name: "unit", nullable: true)
  final String unit;

  DayIngredient(this.id, this.ingredientId, this.expectedQty,
      {this.hadQty, this.qtyUpdatedAtSec, this.unit});

  factory DayIngredient.fromJson(Map<String, dynamic> json) =>
      _$DayIngredientFromJson(json);
  Map<String, dynamic> toJson() => _$DayIngredientToJson(this);

  factory DayIngredient.clone(
      DayIngredient orig, double hadQty, DateTime updatedAt) {
    return DayIngredient(orig.id, orig.ingredientId, orig.expectedQty,
        hadQty: hadQty,
        unit: orig.unit,
        qtyUpdatedAtSec: updatedAt.millisecondsSinceEpoch ~/ 1000);
  }

  DateTime qtyUpdatedAt() {
    if (this.qtyUpdatedAtSec == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(this.qtyUpdatedAtSec * 1000);
  }
}
