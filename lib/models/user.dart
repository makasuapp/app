import 'package:json_annotation/json_annotation.dart';
import 'package:kitchen/models/organization.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  @JsonKey(name: "first_name", nullable: true)
  final String firstName;
  @JsonKey(name: "last_name", nullable: true)
  final String lastName;
  @JsonKey(nullable: true)
  final String email;
  @JsonKey(name: "phone_number", nullable: true)
  final String phoneNumber;

  final List<Organization> organizations;

  User(this.id,
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.organizations});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
