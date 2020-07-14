import 'package:json_annotation/json_annotation.dart';

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

  factory PrepUpdate.withDate(int id, double hadQty, DateTime time) {
    return PrepUpdate(id, hadQty, time.millisecondsSinceEpoch ~/ 1000);
  }

  DateTime time() {
    return DateTime.fromMillisecondsSinceEpoch(this.timeSec * 1000);
  }

  String id() {
    return "$dayPrepId$madeQty$timeSec";
  }
}
