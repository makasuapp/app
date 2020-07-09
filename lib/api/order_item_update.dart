import 'package:json_annotation/json_annotation.dart';

part 'order_item_update.g.dart';

@JsonSerializable()
class OrderItemUpdate {
  @JsonKey(name: "id")
  final int orderItemId;
  @JsonKey(name: "done_at", nullable: true)
  final int doneAtSec;
  @JsonKey(name: "clear_done_at", nullable: true)
  final bool clearDoneAt;
  @JsonKey(name: "time_sec")
  final int timeSec;

  OrderItemUpdate(this.orderItemId, this.timeSec,
      {this.doneAtSec, this.clearDoneAt});

  factory OrderItemUpdate.forDoneAt(int id, DateTime time, DateTime doneAt) {
    return OrderItemUpdate(id, time.millisecondsSinceEpoch ~/ 1000,
        doneAtSec: doneAt.millisecondsSinceEpoch ~/ 1000);
  }

  factory OrderItemUpdate.clearDoneAt(int id, DateTime time) {
    return OrderItemUpdate(id, time.millisecondsSinceEpoch ~/ 1000,
        clearDoneAt: true);
  }

  DateTime time() {
    return DateTime.fromMillisecondsSinceEpoch(this.timeSec * 1000);
  }

  Map<String, dynamic> toJson() => _$OrderItemUpdateToJson(this);
}
