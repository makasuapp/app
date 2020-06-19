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

  String expectedQtyWithUnit() {
    final isInteger = this.expectedQty == this.expectedQty.toInt();
    final qty = isInteger ? this.expectedQty.toInt().toString() : this.expectedQty.toStringAsPrecision(2);

    if (this.unit == null) {
      return qty;
    } else {
      return "$qty ${this.unit}";
    }
  }

  DateTime qtyUpdatedAt() {
    if (this.qtyUpdatedAtSec == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(this.qtyUpdatedAtSec * 1000);
  }
}