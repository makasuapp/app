import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/services/date_converter.dart';

part 'prep_update.g.dart';

@JsonSerializable()
class PrepUpdate {
  @JsonKey(name: "id")
  final int dayPrepId;
  @JsonKey(name: "made_qty")
  final double madeQty;
  @JsonKey(name: "time_sec")
  final int timeSec;

  PrepUpdate(this.dayPrepId, this.madeQty, this.timeSec);

  Map<String, dynamic> toJson() => _$PrepUpdateToJson(this);

  factory PrepUpdate.fromJson(Map<String, dynamic> json) =>
      _$PrepUpdateFromJson(json);

  factory PrepUpdate.withDate(int id, double hadQty, DateTime time) {
    return PrepUpdate(id, hadQty, DateConverter.toServer(time));
  }

  DateTime time() {
    return DateConverter.fromServer(this.timeSec);
  }

  String id() {
    return "$dayPrepId$madeQty$timeSec";
  }
}
