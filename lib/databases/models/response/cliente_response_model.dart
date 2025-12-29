import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/projeto_response_model.dart';
import 'package:farmtracker/domains/models/cliente_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cliente_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClienteResponseModel with EquatableMixin {
  final String uuid;
  final String nome;
  final String email;
  final String celular;
  final String observacao;
  final String endereco;
  final String proprietario;
  final String responsavelTecnico;
  final List<ProjetoResponseModel> projetos;

  ClienteResponseModel({
    required this.uuid,
    required this.nome,
    required this.email,
    required this.celular,
    required this.observacao,
    required this.endereco,
    required this.proprietario,
    required this.responsavelTecnico,
    required this.projetos,
  });

  ClienteResponseModel copyWith({
    String? uuid,
    String? nome,
    String? email,
    String? celular,
    String? observacao,
    String? endereco,
    String? proprietario,
    String? responsavelTecnico,
    List<ProjetoResponseModel>? projetos,
  }) {
    return ClienteResponseModel(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      celular: celular ?? this.celular,
      observacao: observacao ?? this.observacao,
      endereco: endereco ?? this.endereco,
      proprietario: proprietario ?? this.proprietario,
      responsavelTecnico: responsavelTecnico ?? this.responsavelTecnico,
      projetos: projetos ?? this.projetos,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        nome,
        email,
        celular,
        observacao,
        endereco,
        proprietario,
        responsavelTecnico,
        projetos,
      ];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$ClienteResponseModelToJson(this);

  factory ClienteResponseModel.fromJson(Map<String, dynamic> json) => _$ClienteResponseModelFromJson(json);
}

extension ClienteResponseModelMapper on ClienteResponseModel {
  ClienteModel toModel() {
    return ClienteModel(
      uuid: uuid,
      nome: nome,
      email: email,
      celular: celular,
      observacao: observacao,
      proprietario: proprietario,
      responsavelTecnico: responsavelTecnico,
    );
  }
}

extension ClienteResponseModelListMapper on List<ClienteResponseModel> {
  List<ClienteModel> toMapModel() {
    return map((endereco) => endereco.toModel()).toList();
  }
}
