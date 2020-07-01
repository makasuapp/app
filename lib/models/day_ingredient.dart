import 'package:json_annotation/json_annotation.dart';

part 'day_ingredient.g.dart';

@JsonSerializable()
class DayIngredient {
  final int id;
  final String name;
  @JsonKey(name: "expected_qty")
  final double expectedQty;
  @JsonKey(name: "had_qty", nullable: true)
  double hadQty;
  @JsonKey(name: "qty_updated_at", nullable: true)
  int qtyUpdatedAtSec;
  @JsonKey(name: "unit", nullable: true)
  final String unit;

  DayIngredient(this.id, this.name, this.expectedQty, {this.hadQty, this.qtyUpdatedAtSec, this.unit});

  factory DayIngredient.fromJson(Map<String, dynamic> json) => _$DayIngredientFromJson(json);
  Map<String, dynamic> toJson() => _$DayIngredientToJson(this);

  DateTime qtyUpdatedAt() {
    if (this.qtyUpdatedAtSec == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(this.qtyUpdatedAtSec * 1000);
  }
}