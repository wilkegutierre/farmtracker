// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoteModel _$LoteModelFromJson(Map<String, dynamic> json) => LoteModel(
  uuid: json['uuid'] as String,
  projeto: json['projetoId'] as String?,
  nome: json['nome'] as String,
  descricao: json['descricao'] as String,
);

Map<String, dynamic> _$LoteModelToJson(LoteModel instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'projetoId': instance.projeto,
  'nome': instance.nome,
  'descricao': instance.descricao,
};
