import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/services/date_converter.dart';

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
    return InputUpdate(id, hadQty, DateConverter.toServer(time));
  }

  DateTime time() {
    return DateConverter.fromServer(this.timeSec);
  }

  Map<String, dynamic> toJson() => _$InputUpdateToJson(this);
}
