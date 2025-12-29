// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motivo_agenda_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotivoAgendaResponseModel _$MotivoAgendaResponseModelFromJson(
  Map<String, dynamic> json,
) => MotivoAgendaResponseModel(
  uuid: json['uuid'] as String,
  nome: json['nome'] as String,
  descricao: json['descricao'] as String,
);

Map<String, dynamic> _$MotivoAgendaResponseModelToJson(
  MotivoAgendaResponseModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'nome': instance.nome,
  'descricao': instance.descricao,
};
