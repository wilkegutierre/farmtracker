// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projeto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjetoModel _$ProjetoModelFromJson(Map<String, dynamic> json) => ProjetoModel(
  id: json['id'] as String,
  clienteId: json['clienteId'] as String?,
  nome: json['nome'] as String,
  descricao: json['descricao'] as String,
);

Map<String, dynamic> _$ProjetoModelToJson(ProjetoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clienteId': instance.clienteId,
      'nome': instance.nome,
      'descricao': instance.descricao,
    };
