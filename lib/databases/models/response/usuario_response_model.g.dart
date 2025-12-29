// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioResponseModel _$UsuarioResponseModelFromJson(
  Map<String, dynamic> json,
) => UsuarioResponseModel(
  uuid: json['uuid'] as String,
  nome: json['nome'] as String,
  email: json['email'] as String,
  telefone: json['telefone'] as String,
  senha: json['senha'] as String,
  foto: json['foto'] as String,
  tokenAcesso: json['tokenAcesso'] as String,
);

Map<String, dynamic> _$UsuarioResponseModelToJson(
  UsuarioResponseModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'nome': instance.nome,
  'email': instance.email,
  'telefone': instance.telefone,
  'senha': instance.senha,
  'foto': instance.foto,
  'tokenAcesso': instance.tokenAcesso,
};
