import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment_execution_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentExecutionModel with EquatableMixin {
  final String id;
  final int completed;
  final int reason;
  //final int subreason;
  final int hasPest;
  final String pest;
  final String cropPest;
  final String datetime;
  final String todo;
  final String appointmentId;

  AppointmentExecutionModel({
    required this.id,
    required this.completed,
    required this.reason,
    //required this.subreason,
    required this.hasPest,
    required this.pest,
    required this.cropPest,
    required this.datetime,
    required this.todo,
    required this.appointmentId,
  });

  AppointmentExecutionModel copyWith({
    String? id,
    int? completed,
    int? reason,
    //int? subreason,
    int? hasPest,
    String? pest,
    String? cropPest,
    String? datetime,
    String? todo,
    String? appointmentId,
  }) {
    return AppointmentExecutionModel(
      id: id ?? this.id,
      completed: completed ?? this.completed,
      reason: reason ?? this.reason,
      //subreason: subreason ?? this.subreason,
      hasPest: hasPest ?? this.hasPest,
      pest: pest ?? this.pest,
      cropPest: cropPest ?? this.cropPest,
      datetime: datetime ?? this.datetime,
      todo: todo ?? this.todo,
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }

  Map<String, dynamic> toJson() => _$AppointmentExecutionModelToJson(this);

  factory AppointmentExecutionModel.fromJson(Map<String, dynamic> json) => _$AppointmentExecutionModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());

  @override
  List<Object?> get props => [id, completed, reason, hasPest, pest, cropPest, datetime, todo, appointmentId];

  @override
  bool? get stringify => true;
}
