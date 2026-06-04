// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CropModel _$CropModelFromJson(Map<String, dynamic> json) => CropModel(
  id: json['id'] as String,
  name: json['name'] as String,
  orgOwner: json['org_owner'] as String,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  createdBy: json['created_by'] as String?,
);

Map<String, dynamic> _$CropModelToJson(CropModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'org_owner': instance.orgOwner,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'created_by': instance.createdBy,
};
