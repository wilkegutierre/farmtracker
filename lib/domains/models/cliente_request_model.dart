import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cliente_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClienteRequestModel with EquatableMixin {
  final String uuid;
  final String nome;
  final String email;
  final String celular;
  final String observacao;
  final String proprietario;
  final String responsavelTecnico;

  ClienteRequestModel({
    required this.uuid,
    required this.nome,
    required this.email,
    required this.celular,
    required this.observacao,
    required this.proprietario,
    required this.responsavelTecnico,
  });

  ClienteRequestModel copyWith({
    String? uuid,
    String? nome,
    String? email,
    String? celular,
    String? observacao,
    String? proprietario,
    String? responsavelTecnico,
  }) {
    return ClienteRequestModel(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      celular: celular ?? this.celular,
      observacao: observacao ?? this.observacao,
      proprietario: proprietario ?? this.proprietario,
      responsavelTecnico: responsavelTecnico ?? this.responsavelTecnico,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        nome,
        email,
        celular,
        observacao,
        proprietario,
        responsavelTecnico,
      ];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$ClienteRequestModelToJson(this);

  factory ClienteRequestModel.fromJson(Map<String, dynamic> json) => _$ClienteRequestModelFromJson(json);
}
