// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_cultura_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoteCulturaResponseModel _$LoteCulturaResponseModelFromJson(
  Map<String, dynamic> json,
) => LoteCulturaResponseModel(
  loteId: json['loteId'] as String?,
  culturaId: json['culturaId'] as String,
  areaCultura: (json['areaCultura'] as num).toDouble(),
);

Map<String, dynamic> _$LoteCulturaResponseModelToJson(
  LoteCulturaResponseModel instance,
) => <String, dynamic>{
  'loteId': instance.loteId,
  'culturaId': instance.culturaId,
  'areaCultura': instance.areaCultura,
};
