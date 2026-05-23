// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUserRequestModel _$LoginUserRequestModelFromJson(
  Map<String, dynamic> json,
) => LoginUserRequestModel(
  login: json['login'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginUserRequestModelToJson(
  LoginUserRequestModel instance,
) => <String, dynamic>{'login': instance.login, 'password': instance.password};
