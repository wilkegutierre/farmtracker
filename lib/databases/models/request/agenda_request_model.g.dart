// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaRequestModel _$AgendaRequestModelFromJson(Map<String, dynamic> json) =>
    AgendaRequestModel(
      uuid: json['uuid'] as String,
      usuario: json['usuario'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      dataCriacao: json['dataCriacao'] as String,
    );

Map<String, dynamic> _$AgendaRequestModelToJson(AgendaRequestModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'usuario': instance.usuario,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'dataCriacao': instance.dataCriacao,
    };
