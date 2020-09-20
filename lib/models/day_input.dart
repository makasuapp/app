import 'package:json_annotation/json_annotation.dart';

part 'day_input.g.dart';

class DayInputType {
  static const Recipe = "Recipe";
  static const Ingredient = "Ingredient";
}

abstract class DayInputable {
  final String name;
  final double volumeWeightRatio;

  DayInputable(this.name, this.volumeWeightRatio);
}

@JsonSerializable()
class DayInput {
  final int id;
  @JsonKey(name: "inputable_id")
  final int inputableId;
  @JsonKey(name: "inputable_type")
  final String inputableType;
  @JsonKey(name: "expected_qty")
  final double expectedQty;
  @JsonKey(name: "had_qty", nullable: true)
  double hadQty;
  @JsonKey(name: "qty_updated_at", nullable: true)
  int qtyUpdatedAtSec;
  @JsonKey(name: "unit", nullable: true)
  final String unit;

  DayInput(this.id, this.inputableId, this.inputableType, this.expectedQty,
      {this.hadQty, this.qtyUpdatedAtSec, this.unit});

  factory DayInput.fromJson(Map<String, dynamic> json) =>
      _$DayInputFromJson(json);
  Map<String, dynamic> toJson() => _$DayInputToJson(this);

  factory DayInput.clone(DayInput orig, double hadQty, DateTime updatedAt) {
    return DayInput(
        orig.id, orig.inputableId, orig.inputableType, orig.expectedQty,
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
