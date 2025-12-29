// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projeto_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjetoResponseModel _$ProjetoResponseModelFromJson(
  Map<String, dynamic> json,
) => ProjetoResponseModel(
  uuid: json['uuid'] as String,
  nome: json['nome'] as String,
  descricao: json['descricao'] as String,
  lotes: (json['lotes'] as List<dynamic>)
      .map((e) => LoteResponseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProjetoResponseModelToJson(
  ProjetoResponseModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'nome': instance.nome,
  'descricao': instance.descricao,
  'lotes': instance.lotes.map((e) => e.toJson()).toList(),
};
