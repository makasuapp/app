import 'package:json_annotation/json_annotation.dart';

part 'predicted_order.g.dart';

@JsonSerializable()
class PredictedOrder {
  final int id;
  @JsonKey(name: "recipe_id")
  final int recipeId;
  final int quantity;
  @JsonKey(name: "date_sec")
  final int dateSec;

  PredictedOrder(this.id, this.recipeId, this.quantity, this.dateSec);

  factory PredictedOrder.fromJson(Map<String, dynamic> json) =>
      _$PredictedOrderFromJson(json);
}
