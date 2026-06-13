// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pest_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PestResponseModel _$PestResponseModelFromJson(Map<String, dynamic> json) =>
    PestResponseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      orgOwner: json['orgOwner'] as String,
    );

Map<String, dynamic> _$PestResponseModelToJson(PestResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'orgOwner': instance.orgOwner,
    };
