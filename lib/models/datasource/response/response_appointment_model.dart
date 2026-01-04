import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseAppointmentModel with EquatableMixin {
  final String uuid;
  final String user;
  final String costumer;
  final String projectLotCulture;
  final String appointmentDatetime;
  final String type;
  final String todo;
  final int status;

  ResponseAppointmentModel({
    required this.uuid,
    required this.user,
    required this.costumer,
    required this.projectLotCulture,
    required this.appointmentDatetime,
    required this.type,
    required this.todo,
    required this.status,
  });

  ResponseAppointmentModel copyWith({
    String? uuid,
    String? user,
    String? costumer,
    String? projectLotCulture,
    String? appointmentDatetime,
    String? type,
    String? todo,
    int? status,
  }) {
    return ResponseAppointmentModel(
      uuid: uuid ?? this.uuid,
      user: user ?? this.user,
      costumer: costumer ?? this.costumer,
      projectLotCulture: projectLotCulture ?? this.projectLotCulture,
      appointmentDatetime: appointmentDatetime ?? this.appointmentDatetime,
      type: type ?? this.type,
      todo: todo ?? this.todo,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => _$ResponseAppointmentModelToJson(this);

  factory ResponseAppointmentModel.fromJson(Map<String, dynamic> json) => _$ResponseAppointmentModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());

  @override
  List<Object?> get props => [uuid, user, costumer, projectLotCulture, appointmentDatetime, type, todo, status];

  @override
  bool? get stringify => true;
}
