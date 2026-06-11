import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentModel with EquatableMixin {
  final String id;
  final String user;
  final String customer;
  final String project;
  final String datetime;
  final String type;
  final String todo;
  final int status;

  AppointmentModel({
    required this.id,
    required this.user,
    required this.customer,
    required this.project,
    required this.datetime,
    required this.type,
    required this.todo,
    required this.status,
  });

  AppointmentModel copyWith({
    String? id,
    String? user,
    String? customer,
    String? project,
    String? datetime,
    String? type,
    String? todo,
    int? status,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      user: user ?? this.user,
      customer: customer ?? this.customer,
      project: project ?? this.project,
      datetime: datetime ?? this.datetime,
      type: type ?? this.type,
      todo: todo ?? this.todo,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => _$AppointmentModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());

  @override
  List<Object?> get props => [id, user, customer, project, datetime, type, todo, status];

  @override
  bool? get stringify => true;
}
