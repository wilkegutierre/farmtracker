// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/projeto_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:farmtracker/databases/models/response/lote_response_model.dart';

part 'projeto_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjetoResponseModel with EquatableMixin {
  final String uuid;
  final String nome;
  final String descricao;
  final List<LoteResponseModel> lotes;

  ProjetoResponseModel({
    required this.uuid,
    required this.nome,
    required this.descricao,
    required this.lotes,
  });

  @override
  List<Object?> get props => [uuid, nome, descricao, lotes];

  @override
  bool? get stringify => true;

  ProjetoResponseModel copyWith({
    String? uuid,
    String? nome,
    String? descricao,
    List<LoteResponseModel>? lotes,
  }) {
    return ProjetoResponseModel(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      lotes: lotes ?? this.lotes,
    );
  }

  Map<String, dynamic> toJson() => _$ProjetoResponseModelToJson(this);

  factory ProjetoResponseModel.fromJson(Map<String, dynamic> json) => _$ProjetoResponseModelFromJson(json);
}

extension ProjetoResponseModelMapper on ProjetoResponseModel {
  ProjetoModel toModel() {
    return ProjetoModel(
      uuid: uuid,
      nome: nome,
      descricao: descricao,
      lotes: lotes.map((lote) => lote.toModel()).toList(),
    );
  }
}

extension ProjetoResponseModelListMapper on List<ProjetoResponseModel> {
  List<ProjetoModel> toMapModel() {
    return map((projeto) => projeto.toModel()).toList();
  }
}
