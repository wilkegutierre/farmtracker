import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agenda_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AgendaModel with EquatableMixin {
  final String id;
  final String usuario;
  final String cliente;
  final String dataHoraCriacao;
  final String descricao;
  final String motivo;
  final int situacao;
  final String observacao;

  AgendaModel({
    required this.id,
    required this.usuario,
    required this.cliente,
    required this.dataHoraCriacao,
    required this.descricao,
    required this.motivo,
    required this.situacao,
    required this.observacao,
  });

  AgendaModel copyWith({
    String? id,
    String? usuario,
    String? cliente,
    String? dataHoraCriacao,
    String? descricao,
    String? motivo,
    int? situacao,
    String? observacao,
  }) {
    return AgendaModel(
      id: id ?? this.id,
      usuario: usuario ?? this.usuario,
      cliente: cliente ?? this.cliente,
      dataHoraCriacao: dataHoraCriacao ?? this.dataHoraCriacao,
      descricao: descricao ?? this.descricao,
      motivo: motivo ?? this.motivo,
      situacao: situacao ?? this.situacao,
      observacao: observacao ?? this.observacao,
    );
  }

  @override
  List<Object?> get props => [id, usuario, cliente, dataHoraCriacao, descricao, motivo, situacao, observacao];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$AgendaModelToJson(this);

  factory AgendaModel.fromJson(Map<String, dynamic> json) => _$AgendaModelFromJson(json);
}
