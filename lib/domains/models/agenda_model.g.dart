// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaModel _$AgendaModelFromJson(Map<String, dynamic> json) => AgendaModel(
  id: json['id'] as String,
  usuario: json['usuario'] as String,
  cliente: json['cliente'] as String,
  dataHoraCriacao: json['dataHoraCriacao'] as String,
  descricao: json['descricao'] as String,
  motivo: json['motivo'] as String,
  situacao: (json['situacao'] as num).toInt(),
  observacao: json['observacao'] as String,
);

Map<String, dynamic> _$AgendaModelToJson(AgendaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario': instance.usuario,
      'cliente': instance.cliente,
      'dataHoraCriacao': instance.dataHoraCriacao,
      'descricao': instance.descricao,
      'motivo': instance.motivo,
      'situacao': instance.situacao,
      'observacao': instance.observacao,
    };
