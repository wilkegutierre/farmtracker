import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/cliente_response_model.dart';
import 'package:farmtracker/databases/models/response/motivo_agenda_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agenda_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AgendaResponseModel with EquatableMixin {
  final String uuid;
  final int dataCriacao;
  final int dataAgenda;
  final ClienteResponseModel cliente;
  final String descricao;
  final MotivoAgendaResponseModel motivo;
  final int situacao;
  //final int? praga;
  final String? kmAtendimento;
  final String? observacao;

  AgendaResponseModel({
    required this.uuid,
    required this.dataCriacao,
    required this.dataAgenda,
    required this.cliente,
    required this.descricao,
    required this.motivo,
    required this.situacao,
    required this.kmAtendimento,
    required this.observacao,
  });

  AgendaResponseModel copyWith({
    String? uuid,
    int? dataCriacao,
    int? dataAgenda,
    ClienteResponseModel? cliente,
    String? descricao,
    MotivoAgendaResponseModel? motivo,
    int? situacao,
    String? kmAtendimento,
    String? observacao,
  }) {
    return AgendaResponseModel(
      uuid: uuid ?? this.uuid,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAgenda: dataAgenda ?? this.dataAgenda,
      cliente: cliente ?? this.cliente,
      descricao: descricao ?? this.descricao,
      motivo: motivo ?? this.motivo,
      situacao: situacao ?? this.situacao,
      kmAtendimento: kmAtendimento ?? this.kmAtendimento,
      observacao: observacao ?? this.observacao,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        dataCriacao,
        dataAgenda,
        cliente,
        descricao,
        motivo,
        situacao,
        kmAtendimento,
        observacao,
      ];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$AgendaResponseModelToJson(this);

  factory AgendaResponseModel.fromJson(Map<String, dynamic> json) => _$AgendaResponseModelFromJson(json);
}
