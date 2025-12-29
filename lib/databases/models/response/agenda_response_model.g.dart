// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaResponseModel _$AgendaResponseModelFromJson(Map<String, dynamic> json) =>
    AgendaResponseModel(
      uuid: json['uuid'] as String,
      dataCriacao: (json['dataCriacao'] as num).toInt(),
      dataAgenda: (json['dataAgenda'] as num).toInt(),
      cliente: ClienteResponseModel.fromJson(
        json['cliente'] as Map<String, dynamic>,
      ),
      descricao: json['descricao'] as String,
      motivo: MotivoAgendaResponseModel.fromJson(
        json['motivo'] as Map<String, dynamic>,
      ),
      situacao: (json['situacao'] as num).toInt(),
      kmAtendimento: json['kmAtendimento'] as String?,
      observacao: json['observacao'] as String?,
    );

Map<String, dynamic> _$AgendaResponseModelToJson(
  AgendaResponseModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'dataCriacao': instance.dataCriacao,
  'dataAgenda': instance.dataAgenda,
  'cliente': instance.cliente.toJson(),
  'descricao': instance.descricao,
  'motivo': instance.motivo.toJson(),
  'situacao': instance.situacao,
  'kmAtendimento': instance.kmAtendimento,
  'observacao': instance.observacao,
};
