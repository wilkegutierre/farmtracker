// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClienteRequestModel _$ClienteRequestModelFromJson(Map<String, dynamic> json) =>
    ClienteRequestModel(
      uuid: json['uuid'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      celular: json['celular'] as String,
      observacao: json['observacao'] as String,
      proprietario: json['proprietario'] as String,
      responsavelTecnico: json['responsavelTecnico'] as String,
    );

Map<String, dynamic> _$ClienteRequestModelToJson(
  ClienteRequestModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'nome': instance.nome,
  'email': instance.email,
  'celular': instance.celular,
  'observacao': instance.observacao,
  'proprietario': instance.proprietario,
  'responsavelTecnico': instance.responsavelTecnico,
};
