import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agenda_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AgendaRequestModel with EquatableMixin {
  final String uuid;
  final String usuario;
  final String titulo;
  final String descricao;
  final String dataCriacao;

  AgendaRequestModel({
    required this.uuid,
    required this.usuario,
    required this.titulo,
    required this.descricao,
    required this.dataCriacao,
  });

  AgendaRequestModel copyWith({
    String? uuid,
    String? usuario,
    String? titulo,
    String? descricao,
    String? dataCriacao,
  }) {
    return AgendaRequestModel(
      uuid: uuid ?? this.uuid,
      usuario: usuario ?? this.usuario,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  List<Object?> get props => [uuid, usuario, titulo, descricao, dataCriacao];

  @override
  bool? get stringify => true;

  factory AgendaRequestModel.fromJson(Map<String, dynamic> json) => _$AgendaRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AgendaRequestModelToJson(this);

  String toJsonStringfy() => json.encode(toJson());
}
