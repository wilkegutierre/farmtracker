import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_user_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginUserRequestModel with EquatableMixin {
  final String login;
  final String password;

  LoginUserRequestModel({required this.login, required this.password});

  @override
  List<Object?> get props => [login, password];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$LoginUserRequestModelToJson(this);

  factory LoginUserRequestModel.fromJson(Map<String, dynamic> json) => _$LoginUserRequestModelFromJson(json);
}
