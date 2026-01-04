// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_costumer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseCostumerModel _$ResponseCostumerModelFromJson(
  Map<String, dynamic> json,
) => ResponseCostumerModel(
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  propertieName: json['propertieName'] as String,
  technicalResponsible: json['technicalResponsible'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
);

Map<String, dynamic> _$ResponseCostumerModelToJson(
  ResponseCostumerModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'propertieName': instance.propertieName,
  'technicalResponsible': instance.technicalResponsible,
  'email': instance.email,
  'phone': instance.phone,
};
