import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';

part 'usuario_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UsuarioModel with EquatableMixin {
  final String uuid;
  final String nome;
  final String email;
  final String senha;
  final String telefone;
  @JsonKey(name: 'urlFoto')
  final String foto;
  final String tokenAcesso;

  UsuarioModel({
    required this.uuid,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
    required this.foto,
    required this.tokenAcesso,
  });

  UsuarioModel copyWith({
    String? uuid,
    String? nome,
    String? email,
    String? telefone,
    String? senha,
    String? foto,
    String? tokenAcesso,
  }) {
    return UsuarioModel(
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

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$UsuarioModelToJson(this);

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => _$UsuarioModelFromJson(json);
}
