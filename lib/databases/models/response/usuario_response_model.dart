import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/usuario_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UsuarioResponseModel with EquatableMixin {
  final String uuid;
  final String nome;
  final String email;
  final String telefone;
  final String senha;
  final String foto;
  final String tokenAcesso;

  UsuarioResponseModel({
    required this.uuid,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
    required this.foto,
    required this.tokenAcesso,
  });

  UsuarioResponseModel copyWith({
    String? uuid,
    String? nome,
    String? email,
    String? telefone,
    String? senha,
    String? foto,
    String? tokenAcesso,
  }) {
    return UsuarioResponseModel(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      senha: senha ?? this.senha,
      foto: foto ?? this.foto,
      tokenAcesso: tokenAcesso ?? this.tokenAcesso,
    );
  }

  @override
  List<Object?> get props => [uuid, nome, email, telefone, senha, foto, tokenAcesso];

  @override
  bool? get stringify => true;

  factory UsuarioResponseModel.fromJson(Map<String, dynamic> json) => _$UsuarioResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioResponseModelToJson(this);

  String toJsonStringfy() => json.encode(toJson());
}

extension UsuarioResponseModelMapper on UsuarioResponseModel {
  UsuarioModel toModel() {
    return UsuarioModel(
      uuid: uuid,
      nome: nome,
      email: email,
      telefone: telefone,
      senha: senha,
      foto: foto,
      tokenAcesso: tokenAcesso,
    );
  }
}
