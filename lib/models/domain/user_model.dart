import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel with EquatableMixin {
  final String id;
  final String name;
  final String password;
  final String email;
  final String phone;

  UserModel({required this.id, required this.name, required this.password, required this.email, required this.phone});

  UserModel copyWith({String? id, String? name, String? password, String? email, String? phone}) {
    return UserModel(
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

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());
}
