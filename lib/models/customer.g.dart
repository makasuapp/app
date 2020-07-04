// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    json['id'] as int,
    email: json['email'] as String,
    name: json['name'] as String,
    phoneNumber: json['phone_number'] as String,
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
    };
