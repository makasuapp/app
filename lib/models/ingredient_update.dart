import 'package:json_annotation/json_annotation.dart';

part 'ingredient_update.g.dart';

@JsonSerializable()
class IngredientUpdate {
  @JsonKey(name: "id")
  final int dayIngredientId;
  @JsonKey(name: "had_qty")
  final double hadQty;
  @JsonKey(name: "time_sec")
  final int timeSec;

  IngredientUpdate(this.dayIngredientId, this.hadQty, this.timeSec);

  factory IngredientUpdate.withDate(int id, double hadQty, DateTime time) {
    return IngredientUpdate(id, hadQty, time.millisecondsSinceEpoch ~/ 1000);
  }

  DateTime time() {
    return DateTime.fromMillisecondsSinceEpoch(this.timeSec * 1000);
  }

  Map<String, dynamic> toJson() => _$IngredientUpdateToJson(this);
}