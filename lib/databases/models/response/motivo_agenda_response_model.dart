import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'motivo_agenda_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MotivoAgendaResponseModel with EquatableMixin {
  final String uuid;
  final String nome;
  final String descricao;

  MotivoAgendaResponseModel({required this.uuid, required this.nome, required this.descricao});

  MotivoAgendaResponseModel copyWith({
    String? uuid,
    String? nome,
    String? descricao,
  }) {
    return MotivoAgendaResponseModel(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
    );
  }

  @override
  List<Object?> get props => [uuid, nome, descricao];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$MotivoAgendaResponseModelToJson(this);

  factory MotivoAgendaResponseModel.fromJson(Map<String, dynamic> json) => _$MotivoAgendaResponseModelFromJson(json);
}
