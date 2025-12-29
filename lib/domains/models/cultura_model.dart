import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cultura_model.g.dart';

@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class CulturaModel implements EquatableMixin {
  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'nome')
  final String nome;
  @JsonKey(name: 'descricao')
  final String descricao;
  @JsonKey(name: 'urlImagem')
  final String urlImagem;

  CulturaModel({
    required this.uuid,
    required this.nome,
    required this.descricao,
    required this.urlImagem,
  });

  CulturaModel copyWith({
    String? uuid,
    String? nome,
    String? descricao,
    String? urlImagem,
  }) {
    return CulturaModel(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      urlImagem: urlImagem ?? this.urlImagem,
    );
  }

  @override
  List<Object?> get props => [uuid, nome, descricao, urlImagem];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$CulturaModelToJson(this);

  factory CulturaModel.fromJson(Map<String, dynamic> json) => _$CulturaModelFromJson(json);
}
