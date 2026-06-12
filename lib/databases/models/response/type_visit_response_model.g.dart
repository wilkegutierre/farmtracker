// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_visit_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypeVisitResponseModel _$TypeVisitResponseModelFromJson(
  Map<String, dynamic> json,
) => TypeVisitResponseModel(
  id: (json['id'] as num).toInt(),
  description: json['description'] as String,
  orgOwner: json['orgOwner'] as String,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  createdBy: json['createdBy'] as String?,
);

Map<String, dynamic> _$TypeVisitResponseModelToJson(
  TypeVisitResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'orgOwner': instance.orgOwner,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'createdBy': instance.createdBy,
};
