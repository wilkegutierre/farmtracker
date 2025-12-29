// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cultura_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CulturaModel _$CulturaModelFromJson(Map<String, dynamic> json) => CulturaModel(
  uuid: json['uuid'] as String,
  nome: json['nome'] as String,
  descricao: json['descricao'] as String,
  urlImagem: json['urlImagem'] as String,
);

Map<String, dynamic> _$CulturaModelToJson(CulturaModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'urlImagem': instance.urlImagem,
    };
