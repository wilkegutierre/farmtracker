import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseUserModel with EquatableMixin {
  final String id;
  final String name;
  final String password;
  final String email;
  final String phone;

  ResponseUserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
  });

  ResponseUserModel copyWith({String? id, String? name, String? password, String? email, String? phone}) {
    return ResponseUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [id, name, password, email, phone];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$ResponseUserModelToJson(this);

  factory ResponseUserModel.fromJson(Map<String, dynamic> json) => _$ResponseUserModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());
}
