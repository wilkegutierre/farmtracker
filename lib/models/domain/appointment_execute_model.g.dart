// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_execute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentExecutedModel _$AppointmentExecutedModelFromJson(
  Map<String, dynamic> json,
) => AppointmentExecutedModel(
  id: json['id'] as String,
  completed: (json['completed'] as num).toInt(),
  reason: (json['reason'] as num).toInt(),
  submotive: (json['submotive'] as num).toInt(),
  hasPest: (json['hasPest'] as num).toInt(),
  pest: (json['pest'] as num).toInt(),
  projects: (json['projects'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  datetime: json['datetime'] as String,
  todo: json['todo'] as String,
  appointmentId: json['appointmentId'] as String,
);

Map<String, dynamic> _$AppointmentExecutedModelToJson(
  AppointmentExecutedModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'completed': instance.completed,
  'reason': instance.reason,
  'submotive': instance.submotive,
  'hasPest': instance.hasPest,
  'pest': instance.pest,
  'datetime': instance.datetime,
  'projects': instance.projects,
  'todo': instance.todo,
  'appointmentId': instance.appointmentId,
};
