// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projeto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjetoModel _$ProjetoModelFromJson(Map<String, dynamic> json) => ProjetoModel(
  uuid: json['uuid'] as String,
  clienteId: json['clienteId'] as String?,
  nome: json['nome'] as String,
  descricao: json['descricao'] as String,
);

Map<String, dynamic> _$ProjetoModelToJson(ProjetoModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'clienteId': instance.clienteId,
      'nome': instance.nome,
      'descricao': instance.descricao,
    };
