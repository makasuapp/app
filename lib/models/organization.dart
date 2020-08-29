import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/models/kitchen.dart';

part 'organization.g.dart';

@JsonSerializable()
class Organization {
  final int id;
  final String name;
  final String role;
  //TOOD(permissions): don't expose this here
  @JsonKey(name: "kitchen_id", nullable: true)
  final String kitchenId;

  final List<Kitchen> kitchens;

  Organization(this.id, this.name, this.role, {this.kitchenId, this.kitchens});

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}
