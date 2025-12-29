import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/endereco_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'endereco_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EnderecoResponseModel with EquatableMixin {
  final String uuid;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;
  final String cep;
  final int numero;
  final String complemento;
  final bool principal;
  final String pessoa;

  EnderecoResponseModel({
    required this.uuid,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.cep,
    required this.numero,
    required this.complemento,
    required this.principal,
    required this.pessoa,
  });

  EnderecoResponseModel copyWith({
    String? uuid,
    String? logradouro,
    String? bairro,
    String? cidade,
    String? uf,
    String? cep,
    int? numero,
    String? complemento,
    bool? principal,
    String? pessoa,
  }) {
    return EnderecoResponseModel(
      uuid: uuid ?? this.uuid,
      logradouro: logradouro ?? this.logradouro,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      principal: principal ?? this.principal,
      pessoa: pessoa ?? this.pessoa,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        logradouro,
        bairro,
        cidade,
        uf,
        cep,
        numero,
        complemento,
        principal,
        pessoa,
      ];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$EnderecoResponseModelToJson(this);

  factory EnderecoResponseModel.fromJson(Map<String, dynamic> json) => _$EnderecoResponseModelFromJson(json);
}

extension EnderecoResponseModelMapper on EnderecoResponseModel {
  EnderecoModel toModel() {
    return EnderecoModel(
      uuid: uuid,
      logradouro: logradouro,
      bairro: bairro,
      cidade: cidade,
      uf: uf,
      cep: cep,
      numero: numero,
      complemento: complemento,
      principal: principal == true ? 1 : 0,
      pessoa: pessoa,
    );
  }
}

extension EnderecoResponseModelListMapper on List<EnderecoResponseModel> {
  List<EnderecoModel> toMapModel() {
    return map((endereco) => endereco.toModel()).toList();
  }
}
