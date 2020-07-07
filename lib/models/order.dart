import 'package:json_annotation/json_annotation.dart';
import './order_item.dart';
import './customer.dart';

part 'order.g.dart';

class OrderState {
  final int id;
  final String state;
  final String next;
  final String nextAction;

  OrderState(this.id, this.state, this.next, this.nextAction);

  static OrderState get(String state) {
    switch (state) {
      case "new":
        return OrderState.newOrder();
      case "started":
        return OrderState.started();
      case "done":
        return OrderState.done();
      case "delivered":
        return OrderState.delivered();
      default:
        throw new Exception("unexpected order state");
    }
  }

  @override
  int get hashCode => this.id;
  @override
  bool operator ==(o) => o is OrderState && o.id == this.id;

  factory OrderState.newOrder() => OrderState(1, "new", "started", "start");
  factory OrderState.started() => OrderState(2, "started", "done", "finish");
  factory OrderState.done() => OrderState(3, "done", "delivered", "deliver");
  factory OrderState.delivered() => OrderState(4, "delivered", null, null);
}

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
    return OrderState.get(this.state);
  }
}
