import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_costumer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseCostumerModel with EquatableMixin {
  final String uuid;
  final String name;
  final String propertieName;
  final String technicalResponsible;
  final String email;
  final String phone;

  ResponseCostumerModel({
    required this.uuid,
    required this.name,
    required this.propertieName,
    required this.technicalResponsible,
    required this.email,
    required this.phone,
  });

  ResponseCostumerModel copyWith({
    String? uuid,
    String? name,
    String? propertieName,
    String? technicalResponsible,
    String? email,
    String? phone,
  }) {
    return ResponseCostumerModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      propertieName: propertieName ?? this.propertieName,
      technicalResponsible: technicalResponsible ?? this.technicalResponsible,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [uuid, name, propertieName, technicalResponsible, email, phone];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$ResponseCostumerModelToJson(this);

  factory ResponseCostumerModel.fromJson(Map<String, dynamic> json) => _$ResponseCostumerModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());
}
