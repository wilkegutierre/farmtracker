// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_cultura_area_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClienteCulturaAreaResponseModel _$ClienteCulturaAreaResponseModelFromJson(
  Map<String, dynamic> json,
) => ClienteCulturaAreaResponseModel(
  cliente: json['cliente'] as String,
  cultura: json['cultura'] as String,
  area: (json['area'] as num).toDouble(),
);

Map<String, dynamic> _$ClienteCulturaAreaResponseModelToJson(
  ClienteCulturaAreaResponseModel instance,
) => <String, dynamic>{
  'cliente': instance.cliente,
  'cultura': instance.cultura,
  'area': instance.area,
};
