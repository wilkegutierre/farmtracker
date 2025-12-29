// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClienteResponseModel _$ClienteResponseModelFromJson(
  Map<String, dynamic> json,
) => ClienteResponseModel(
  uuid: json['uuid'] as String,
  nome: json['nome'] as String,
  email: json['email'] as String,
  celular: json['celular'] as String,
  observacao: json['observacao'] as String,
  endereco: json['endereco'] as String,
  proprietario: json['proprietario'] as String,
  responsavelTecnico: json['responsavelTecnico'] as String,
  projetos: (json['projetos'] as List<dynamic>)
      .map((e) => ProjetoResponseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClienteResponseModelToJson(
  ClienteResponseModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'nome': instance.nome,
  'email': instance.email,
  'celular': instance.celular,
  'observacao': instance.observacao,
  'endereco': instance.endereco,
  'proprietario': instance.proprietario,
  'responsavelTecnico': instance.responsavelTecnico,
  'projetos': instance.projetos.map((e) => e.toJson()).toList(),
};
