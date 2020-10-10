import 'package:json_annotation/json_annotation.dart';
import './order_item.dart';
import './customer.dart';

part 'order.g.dart';

class OrderState {
  final int id;
  final String state;
  final String text;
  final String next;
  final String nextAction;

  OrderState(this.id, this.state, this.text, this.next, this.nextAction);

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

  factory OrderState.newOrder() =>
      OrderState(1, "new", "Not Started", "started", "start");
  factory OrderState.started() =>
      OrderState(2, "started", "Started", "done", "finish");
  factory OrderState.done() =>
      OrderState(3, "done", "Awaiting Pickup", "delivered", "deliver");
  factory OrderState.delivered() =>
      OrderState(4, "delivered", "Delivered", null, null);
}

@JsonSerializable()
class Order {
  final int id;
  @JsonKey(name: "order_id")
  final String externalId;
  final String state;
  @JsonKey(name: "order_type")
  final String orderType;
  @JsonKey(name: "created_at")
  final int createdAtSec;
  @JsonKey(name: "for_time", nullable: true)
  final int forSec;
  @JsonKey(name: "integration_type", nullable: true)
  final String integrationType;
  @JsonKey(nullable: true)
  final String comment;

  final List<OrderItem> items;
  final Customer customer;

  Order(this.id, this.state, this.orderType, this.createdAtSec, this.items,
      this.customer, this.externalId,
      {this.integrationType, this.forSec, this.comment});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  //note we can't set null to values with optional params like this
  factory Order.clone(Order orig,
      {String state,
      String orderType,
      int createdAtSec,
      List<OrderItem> items,
      Customer customer,
      int forSec}) {
    return Order(
        orig.id,
        state ?? orig.state,
        orderType ?? orig.orderType,
        createdAtSec ?? orig.createdAtSec,
        items ?? orig.items,
        customer ?? orig.customer,
        orig.externalId,
        integrationType: orig.integrationType,
        forSec: forSec ?? orig.forSec,
        comment: orig.comment);
  }

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
