// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_cultura_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoteCulturaModel _$LoteCulturaModelFromJson(Map<String, dynamic> json) =>
    LoteCulturaModel(
      lote: json['loteId'] as String,
      cultura: json['culturaId'] as String,
      areaCultura: (json['areaCultura'] as num).toDouble(),
    );

Map<String, dynamic> _$LoteCulturaModelToJson(LoteCulturaModel instance) =>
    <String, dynamic>{
      'loteId': instance.lote,
      'culturaId': instance.cultura,
      'areaCultura': instance.areaCultura,
    };
