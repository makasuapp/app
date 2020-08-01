import 'package:json_annotation/json_annotation.dart';

part 'procurement_update.g.dart';

@JsonSerializable()
class ProcurementUpdate {
  @JsonKey(name: "id")
  final int procurementItemId;
  @JsonKey(name: "got_qty", nullable: true)
  final double gotQty;
  @JsonKey(name: "got_unit", nullable: true)
  final String gotUnit;
  @JsonKey(name: "price_cents", nullable: true)
  final int priceCents;
  @JsonKey(name: "price_unit", nullable: true)
  final String priceUnit;

  ProcurementUpdate(this.procurementItemId,
      {this.gotQty, this.gotUnit, this.priceCents, this.priceUnit});

  Map<String, dynamic> toJson() => _$ProcurementUpdateToJson(this);

  String id() {
    return "$procurementItemId $gotQty $gotUnit $priceCents $priceUnit";
  }
}
