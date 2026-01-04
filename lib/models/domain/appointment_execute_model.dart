import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment_execute_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentExecutedModel with EquatableMixin {
  final String uuid;
  final int completed;
  final int reason;
  final int submotive;
  final int hasPest;
  final int pest;
  // TODO:(wilkealmeida) campo abaixo recebe dateTime formatado
  final String datetimeAppointment;
  final List<String> projectLotCult;
  final double hectares;
  final String todo;

  AppointmentExecutedModel({
    required this.uuid,
    required this.completed,
    required this.reason,
    required this.submotive,
    required this.hasPest,
    required this.pest,
    required this.projectLotCult,
    required this.datetimeAppointment,
    required this.hectares,
    required this.todo,
  });

  AppointmentExecutedModel copyWith({
    String? uuid,
    int? completed,
    int? reason,
    int? submotive,
    int? hasPest,
    int? pest,
    List<String>? projectLotCult,
    String? datetimeAppointment,
    double? hectares,
    String? todo,
  }) {
    return AppointmentExecutedModel(
      uuid: uuid ?? this.uuid,
      completed: completed ?? this.completed,
      reason: reason ?? this.reason,
      submotive: submotive ?? this.submotive,
      hasPest: hasPest ?? this.hasPest,
      pest: pest ?? this.pest,
      projectLotCult: projectLotCult ?? this.projectLotCult,
      datetimeAppointment: datetimeAppointment ?? this.datetimeAppointment,
      hectares: hectares ?? this.hectares,
      todo: todo ?? this.todo,
    );
  }

  Map<String, dynamic> toJson() => _$AppointmentExecutedModelToJson(this);

  factory AppointmentExecutedModel.fromJson(Map<String, dynamic> json) => _$AppointmentExecutedModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());

  @override
  List<Object?> get props => [
    uuid,
    completed,
    reason,
    submotive,
    hasPest,
    pest,
    projectLotCult,
    datetimeAppointment,
    hectares,
    todo,
  ];

  @override
  bool? get stringify => true;
}
