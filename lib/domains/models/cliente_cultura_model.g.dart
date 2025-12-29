// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_cultura_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClienteCulturaModel _$ClienteCulturaModelFromJson(Map<String, dynamic> json) =>
    ClienteCulturaModel(
      cliente: json['cliente'] as String,
      cultura: json['cultura'] as String,
      area: (json['area'] as num).toDouble(),
      projeto: json['projeto'] as String,
      lote: json['lote'] as String,
    );

Map<String, dynamic> _$ClienteCulturaModelToJson(
  ClienteCulturaModel instance,
) => <String, dynamic>{
  'cliente': instance.cliente,
  'cultura': instance.cultura,
  'area': instance.area,
  'lote': instance.lote,
  'projeto': instance.projeto,
};
