import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/cultura_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cultura_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CulturaResponseModel with EquatableMixin {
  final String uuid;
  final String nome;
  final String descricao;
  final String lote;
  final String urlImagem;

  CulturaResponseModel({
    required this.uuid,
    required this.nome,
    required this.descricao,
    required this.lote,
    required this.urlImagem,
  });

  CulturaResponseModel copyWith({String? uuid, String? nome, String? descricao, String? lote, String? urlImagem}) {
    return CulturaResponseModel(
      uuid: uuid ?? this.uuid,
      descricao: descricao ?? this.descricao,
      lote: lote ?? this.lote,
      nome: nome ?? this.nome,
      urlImagem: urlImagem ?? this.urlImagem,
    );
  }

  @override
  List<Object?> get props => [uuid, nome, descricao, lote, urlImagem];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$CulturaResponseModelToJson(this);

  factory CulturaResponseModel.fromJson(Map<String, dynamic> json) => _$CulturaResponseModelFromJson(json);
}

extension CulturaResponseModelMapper on CulturaResponseModel {
  CulturaModel toModel() {
    return CulturaModel(uuid: uuid, nome: nome, descricao: descricao, urlImagem: urlImagem);
  }
}

extension CulturasResponseModelMapper on List<CulturaResponseModel> {
  List<CulturaModel> toMapModel() {
    return map((cultura) => cultura.toModel()).toList();
  }
}
