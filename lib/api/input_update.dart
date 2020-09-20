import 'package:json_annotation/json_annotation.dart';

part 'input_update.g.dart';

@JsonSerializable()
class InputUpdate {
  @JsonKey(name: "id")
  final int dayInputId;
  @JsonKey(name: "had_qty")
  final double hadQty;
  @JsonKey(name: "time_sec")
  final int timeSec;

  InputUpdate(this.dayInputId, this.hadQty, this.timeSec);

  factory InputUpdate.fromJson(Map<String, dynamic> json) =>
      _$InputUpdateFromJson(json);

  factory InputUpdate.withDate(int id, double hadQty, DateTime time) {
    return InputUpdate(id, hadQty, time.millisecondsSinceEpoch ~/ 1000);
  }

  DateTime time() {
    return DateTime.fromMillisecondsSinceEpoch(this.timeSec * 1000);
  }

  Map<String, dynamic> toJson() => _$InputUpdateToJson(this);
}
