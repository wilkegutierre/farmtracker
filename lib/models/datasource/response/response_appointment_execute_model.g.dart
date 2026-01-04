// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_appointment_execute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseAppointmentExecutedModel _$ResponseAppointmentExecutedModelFromJson(
  Map<String, dynamic> json,
) => ResponseAppointmentExecutedModel(
  uuid: json['uuid'] as String,
  completed: (json['completed'] as num).toInt(),
  reason: (json['reason'] as num).toInt(),
  submotive: (json['submotive'] as num).toInt(),
  hasPest: (json['hasPest'] as num).toInt(),
  pest: (json['pest'] as num).toInt(),
  projectLotCult: (json['projectLotCult'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  datetimeAppointment: json['datetimeAppointment'] as String,
  hectares: (json['hectares'] as num).toDouble(),
  todo: json['todo'] as String,
);

Map<String, dynamic> _$ResponseAppointmentExecutedModelToJson(
  ResponseAppointmentExecutedModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'completed': instance.completed,
  'reason': instance.reason,
  'submotive': instance.submotive,
  'hasPest': instance.hasPest,
  'pest': instance.pest,
  'datetimeAppointment': instance.datetimeAppointment,
  'projectLotCult': instance.projectLotCult,
  'hectares': instance.hectares,
  'todo': instance.todo,
};
