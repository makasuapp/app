import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/services/unit_converter.dart';

part 'procurement_item.g.dart';

@JsonSerializable()
class ProcurementItem {
  final int id;
  @JsonKey(name: "ingredient_id")
  final int ingredientId;
  @JsonKey(name: "procurement_order_id")
  final int procurementOrderId;
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

  ProcurementItem(
      this.id, this.ingredientId, this.procurementOrderId, this.quantity,
      {this.unit, this.gotQty, this.gotUnit, this.priceCents, this.priceUnit});

  factory ProcurementItem.fromJson(Map<String, dynamic> json) =>
      _$ProcurementItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProcurementItemToJson(this);

  bool gotten({double volumeWeightRatio}) {
    if (this.gotQty == null) return false;

    try {
      final gotInOrigUnits = UnitConverter.convert(this.gotQty,
          inputUnit: this.gotUnit,
          outputUnit: this.unit,
          volumeWeightRatio: volumeWeightRatio);

      return gotInOrigUnits >= this.quantity;
    } catch (err) {
      //can't convert, just assume it's gotten
      return true;
    }
  }

  factory ProcurementItem.clone(ProcurementItem orig,
      {double gotQty, String gotUnit, int priceCents, String priceUnit}) {
    return ProcurementItem(
        orig.id, orig.ingredientId, orig.procurementOrderId, orig.quantity,
        unit: orig.unit,
        gotQty: gotQty,
        gotUnit: gotUnit,
        priceCents: priceCents,
        priceUnit: priceUnit);
  }
}
