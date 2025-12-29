// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUserRequestModel _$LoginUserRequestModelFromJson(
  Map<String, dynamic> json,
) => LoginUserRequestModel(
  acesso: json['acesso'] as String,
  senha: json['senha'] as String,
);

Map<String, dynamic> _$LoginUserRequestModelToJson(
  LoginUserRequestModel instance,
) => <String, dynamic>{'acesso': instance.acesso, 'senha': instance.senha};
