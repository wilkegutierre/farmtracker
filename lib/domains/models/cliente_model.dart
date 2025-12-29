import 'package:farmtracker/domains/models/cliente_request_model.dart';
import 'package:farmtracker/domains/models/endereco_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';
import 'package:equatable/equatable.dart';

part 'cliente_model.g.dart';

@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class ClienteModel with EquatableMixin {
  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'nome')
  final String nome;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'celular')
  final String celular;
  @JsonKey(name: 'observacao')
  final String observacao;
  final List<EnderecoModel>? enderecos;
  @JsonKey(name: 'proprietario')
  final String proprietario;
  @JsonKey(name: 'responsavelTecnico')
  final String responsavelTecnico;

  ClienteModel({
    required this.uuid,
    required this.nome,
    required this.email,
    required this.celular,
    required this.observacao,
    this.enderecos,
    required this.proprietario,
    required this.responsavelTecnico,
  });

  ClienteModel copyWith({
    String? uuid,
    String? nome,
    String? email,
    String? celular,
    String? observacao,
    List<EnderecoModel>? enderecos,
    String? proprietario,
    String? responsavelTecnico,
  }) {
    return ClienteModel(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      celular: celular ?? this.celular,
      observacao: observacao ?? this.observacao,
      enderecos: enderecos ?? this.enderecos,
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
        enderecos,
        proprietario,
        responsavelTecnico,
      ];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$ClienteModelToJson(this);

  factory ClienteModel.fromJson(Map<String, dynamic> json) => _$ClienteModelFromJson(json);
}

extension ClienteModelMapper on ClienteModel {
  ClienteRequestModel toRequestModel() => ClienteRequestModel(
        uuid: uuid,
        nome: nome,
        email: email,
        celular: celular,
        observacao: observacao,
        proprietario: proprietario,
        responsavelTecnico: responsavelTecnico,
      );
}
