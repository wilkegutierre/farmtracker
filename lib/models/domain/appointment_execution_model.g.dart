// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_execution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentExecutionModel _$AppointmentExecutionModelFromJson(
  Map<String, dynamic> json,
) => AppointmentExecutionModel(
  id: json['id'] as String,
  completed: (json['completed'] as num).toInt(),
  reason: (json['reason'] as num).toInt(),
  hasPest: (json['hasPest'] as num).toInt(),
  pest: json['pest'] as String,
  cropPest: json['cropPest'] as String,
  datetime: json['datetime'] as String,
  todo: json['todo'] as String,
  appointmentId: json['appointmentId'] as String,
);

Map<String, dynamic> _$AppointmentExecutionModelToJson(
  AppointmentExecutionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'completed': instance.completed,
  'reason': instance.reason,
  'hasPest': instance.hasPest,
  'pest': instance.pest,
  'cropPest': instance.cropPest,
  'datetime': instance.datetime,
  'todo': instance.todo,
  'appointmentId': instance.appointmentId,
};
