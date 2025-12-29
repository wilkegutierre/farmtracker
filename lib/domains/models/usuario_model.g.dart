// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioModel _$UsuarioModelFromJson(Map<String, dynamic> json) => UsuarioModel(
  uuid: json['uuid'] as String,
  nome: json['nome'] as String,
  email: json['email'] as String,
  telefone: json['telefone'] as String,
  senha: json['senha'] as String,
  foto: json['urlFoto'] as String,
  tokenAcesso: json['tokenAcesso'] as String,
);

Map<String, dynamic> _$UsuarioModelToJson(UsuarioModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'nome': instance.nome,
      'email': instance.email,
      'senha': instance.senha,
      'telefone': instance.telefone,
      'urlFoto': instance.foto,
      'tokenAcesso': instance.tokenAcesso,
    };
