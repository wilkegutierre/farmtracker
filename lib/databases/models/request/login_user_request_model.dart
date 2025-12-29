import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_user_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginUserRequestModel with EquatableMixin {
  final String acesso;
  final String senha;

  LoginUserRequestModel({required this.acesso, required this.senha});

  @override
  List<Object?> get props => [acesso, senha];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$LoginUserRequestModelToJson(this);

  factory LoginUserRequestModel.fromJson(Map<String, dynamic> json) => _$LoginUserRequestModelFromJson(json);
}
