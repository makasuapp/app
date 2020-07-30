import 'package:json_annotation/json_annotation.dart';

part 'procurement_item.g.dart';

@JsonSerializable()
class ProcurementItem {
  final int id;
  @JsonKey(name: "ingredient_id")
  final int ingredientId;
  final double quantity;
  @JsonKey(nullable: true)
  final String unit;
  @JsonKey(name: "got_qty", nullable: true)
  final double gotQty;
  @JsonKey(name: "got_unit", nullable: true)
  final String gotUnit;
  @JsonKey(name: "price_cents", nullable: true)
  final int priceCents;
  @JsonKey(name: "price_unit", nullable: true)
  final String priceUnit;

  ProcurementItem(this.id, this.ingredientId, this.quantity,
      {this.unit, this.gotQty, this.gotUnit, this.priceCents, this.priceUnit});

  factory ProcurementItem.fromJson(Map<String, dynamic> json) =>
      _$ProcurementItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProcurementItemToJson(this);
}
