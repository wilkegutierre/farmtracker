// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      uuid: json['uuid'] as String,
      user: json['user'] as String,
      costumer: json['costumer'] as String,
      projectLotCulture: json['projectLotCulture'] as String,
      appointmentDatetime: json['appointmentDatetime'] as String,
      type: json['type'] as String,
      todo: json['todo'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'user': instance.user,
      'costumer': instance.costumer,
      'projectLotCulture': instance.projectLotCulture,
      'appointmentDatetime': instance.appointmentDatetime,
      'type': instance.type,
      'todo': instance.todo,
      'status': instance.status,
    };
