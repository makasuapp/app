import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  final int id;
  @JsonKey(name: "recipe_id")
  final int recipeId;
  @JsonKey(name: "price_cents")
  final int priceCents;
  final int quantity;
  @JsonKey(name: "started_at", nullable: true)
  final int startedAtSec;
  @JsonKey(name: "done_at", nullable: true)
  final int doneAtSec;

  OrderItem(this.id, this.recipeId, this.priceCents, this.quantity,
      {this.startedAtSec, this.doneAtSec});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  factory OrderItem.clone(OrderItem orig, int startedAtSec, int doneAtSec,
      {int recipeId, int priceCents, int quantity}) {
    return OrderItem(orig.id, recipeId ?? orig.recipeId,
        priceCents ?? orig.priceCents, quantity ?? orig.quantity,
        startedAtSec: startedAtSec, doneAtSec: doneAtSec);
  }

  DateTime startedAt() {
    if (this.startedAtSec == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(this.startedAtSec * 1000);
  }

  DateTime doneAt() {
    if (this.doneAtSec == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(this.doneAtSec * 1000);
  }
}
