// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_entity_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseEntityResponseModel _$BaseEntityResponseModelFromJson(
  Map<String, dynamic> json,
) => BaseEntityResponseModel(
  id: json['id'] as String,
  orgOwner: json['orgOwner'] as String,
  name: json['name'] as String?,
  type: json['type'] as String?,
  docNumber: json['docNumber'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  createdBy: json['createdBy'] as String?,
);

Map<String, dynamic> _$BaseEntityResponseModelToJson(
  BaseEntityResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'orgOwner': instance.orgOwner,
  'name': instance.name,
  'type': instance.type,
  'docNumber': instance.docNumber,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'createdBy': instance.createdBy,
};
