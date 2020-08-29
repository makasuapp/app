import 'package:json_annotation/json_annotation.dart';

part 'kitchen.g.dart';

@JsonSerializable()
class Kitchen {
  final int id;
  final String name;

  Kitchen(this.id, this.name);

  factory Kitchen.fromJson(Map<String, dynamic> json) =>
      _$KitchenFromJson(json);
  Map<String, dynamic> toJson() => _$KitchenToJson(this);
}
