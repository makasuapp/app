// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyUserResponse _$VerifyUserResponseFromJson(Map<String, dynamic> json) {
  return VerifyUserResponse(
    User.fromJson(json['user'] as Map<String, dynamic>),
    json['token'] as String,
  );
}

Map<String, dynamic> _$VerifyUserResponseToJson(VerifyUserResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.apiToken,
    };
