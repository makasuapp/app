// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) {
  return Organization(
    json['id'] as int,
    json['name'] as String,
    json['role'] as String,
    kitchenId: json['kitchen_id'] as String,
    kitchens: (json['kitchens'] as List)
        .map((e) => Kitchen.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'kitchen_id': instance.kitchenId,
      'kitchens': instance.kitchens,
    };
