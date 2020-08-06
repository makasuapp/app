import 'package:json_annotation/json_annotation.dart';
import './procurement_item.dart';

part 'procurement_order.g.dart';

@JsonSerializable()
class ProcurementOrder {
  final int id;
  @JsonKey(name: "for_date")
  final int forDateSec;
  @JsonKey(name: "order_type")
  final String orderType;
  @JsonKey(name: "vendor_name")
  final String vendorName;

  final List<ProcurementItem> items;

  ProcurementOrder(
      this.id, this.forDateSec, this.orderType, this.vendorName, this.items);

  factory ProcurementOrder.fromJson(Map<String, dynamic> json) =>
      _$ProcurementOrderFromJson(json);
  Map<String, dynamic> toJson() => _$ProcurementOrderToJson(this);

  DateTime forDate() {
    return DateTime.fromMillisecondsSinceEpoch(this.forDateSec * 1000);
  }

  factory ProcurementOrder.clone(
      ProcurementOrder orig, List<ProcurementItem> items) {
    return ProcurementOrder(
        orig.id, orig.forDateSec, orig.orderType, orig.vendorName, items);
  }
}
