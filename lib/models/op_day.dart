import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/models/predicted_order.dart';
import 'day_input.dart';
import './day_prep.dart';

part 'op_day.g.dart';

@JsonSerializable()
class OpDay {
  @JsonKey(name: "date_sec")
  final int dateSec;
  final List<DayInput> inputs;
  final List<DayPrep> prep;
  @JsonKey(name: "predicted_orders")
  final List<PredictedOrder> predictedOrders;

  OpDay(this.dateSec, this.inputs, this.prep, this.predictedOrders);

  factory OpDay.fromJson(Map<String, dynamic> json) => _$OpDayFromJson(json);
  Map<String, dynamic> toJson() => _$OpDayToJson(this);

  DateTime date() {
    return DateTime.fromMillisecondsSinceEpoch(this.dateSec * 1000);
  }
}
