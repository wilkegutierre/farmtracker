import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment_execute_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentExecutedModel with EquatableMixin {
  final String id;
  final int completed;
  final int reason;
  final int submotive;
  final int hasPest;
  final int pest;
  // TODO:(wilkealmeida) campo abaixo recebe dateTime formatado
  final String datetime;
  final List<String> projects;
  final String todo;
  final String appointmentId;

  AppointmentExecutedModel({
    required this.id,
    required this.completed,
    required this.reason,
    required this.submotive,
    required this.hasPest,
    required this.pest,
    required this.projects,
    required this.datetime,
    required this.todo,
    required this.appointmentId,
  });

  AppointmentExecutedModel copyWith({
    String? id,
    int? completed,
    int? reason,
    int? submotive,
    int? hasPest,
    int? pest,
    List<String>? projects,
    String? datetime,
    String? todo,
    String? appointmentId,
  }) {
    return AppointmentExecutedModel(
      id: id ?? this.id,
      completed: completed ?? this.completed,
      reason: reason ?? this.reason,
      submotive: submotive ?? this.submotive,
      hasPest: hasPest ?? this.hasPest,
      pest: pest ?? this.pest,
      projects: projects ?? this.projects,
      datetime: datetime ?? this.datetime,
      todo: todo ?? this.todo,
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }

  Map<String, dynamic> toJson() => _$AppointmentExecutedModelToJson(this);

  factory AppointmentExecutedModel.fromJson(Map<String, dynamic> json) => _$AppointmentExecutedModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());

  @override
  List<Object?> get props => [id, completed, reason, submotive, hasPest, pest, projects, datetime, todo, appointmentId];

  @override
  bool? get stringify => true;
}
