// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationResponseModel _$OrganizationResponseModelFromJson(
  Map<String, dynamic> json,
) => OrganizationResponseModel(
  id: json['id'] as String,
  description: json['description'] as String?,
  addressId: json['addressId'] as String,
);

Map<String, dynamic> _$OrganizationResponseModelToJson(
  OrganizationResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'addressId': instance.addressId,
};
