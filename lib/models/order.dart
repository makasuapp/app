import 'package:json_annotation/json_annotation.dart';
import './order_item.dart';
import './customer.dart';

part 'order.g.dart';

enum OrderState { New, Started, Done, Delivered }

@JsonSerializable()
class Order {
  final int id;
  final String state;
  @JsonKey(name: "order_type")
  final String orderType;
  @JsonKey(name: "created_at")
  final int createdAtSec;
  @JsonKey(name: "for_time", nullable: true)
  final int forSec;

  final List<OrderItem> items;
  final Customer customer;

  Order(this.id, this.state, this.orderType, this.createdAtSec, this.items,
      this.customer,
      {this.forSec});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  bool isPreorder() {
    return this.forSec != null;
  }

  int forTimeSec() {
    if (this.isPreorder()) {
      return this.forSec;
    } else {
      return this.createdAtSec;
    }
  }

  DateTime forTime() {
    return DateTime.fromMillisecondsSinceEpoch(this.forTimeSec() * 1000);
  }

  OrderState orderState() {
    switch (this.state) {
      case "new":
        return OrderState.New;
      case "started":
        return OrderState.Started;
      case "done":
        return OrderState.Done;
      case "delivered":
        return OrderState.Delivered;
      default:
        throw new Exception("unexpected order state");
    }
  }
}
