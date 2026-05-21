import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginUserModel with EquatableMixin {
  final String login;
  final String password;

  LoginUserModel({required this.login, required this.password});

  LoginUserModel copyWith({String? login, String? password}) {
    return LoginUserModel(login: login ?? this.login, password: password ?? this.password);
  }

  @override
  List<Object?> get props => [login, password];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$LoginUserModelToJson(this);

  factory LoginUserModel.fromJson(Map<String, dynamic> json) => _$LoginUserModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());
}
