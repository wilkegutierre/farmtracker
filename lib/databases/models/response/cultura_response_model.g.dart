// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cultura_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CulturaResponseModel _$CulturaResponseModelFromJson(
  Map<String, dynamic> json,
) => CulturaResponseModel(
  uuid: json['uuid'] as String,
  nome: json['nome'] as String,
  descricao: json['descricao'] as String,
  lote: json['lote'] as String,
  urlImagem: json['urlImagem'] as String,
);

Map<String, dynamic> _$CulturaResponseModelToJson(
  CulturaResponseModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'nome': instance.nome,
  'descricao': instance.descricao,
  'lote': instance.lote,
  'urlImagem': instance.urlImagem,
};
