import 'package:json_annotation/json_annotation.dart';
import '../models/user.dart';

part 'verify_user_response.g.dart';

@JsonSerializable()
class VerifyUserResponse {
  final User user;
  @JsonKey(name: "token")
  final String apiToken;

  VerifyUserResponse(this.user, this.apiToken);

  factory VerifyUserResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyUserResponseFromJson(json);
}
