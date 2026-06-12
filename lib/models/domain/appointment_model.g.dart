// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: json['id'] as String,
      user: json['user'] as String,
      customer: json['customer'] as String,
      project: json['project'] as String,
      datetime: json['datetime'] as String,
      type: (json['type'] as num).toInt(),
      todo: json['todo'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'customer': instance.customer,
      'project': instance.project,
      'datetime': instance.datetime,
      'type': instance.type,
      'todo': instance.todo,
      'status': instance.status,
    };
