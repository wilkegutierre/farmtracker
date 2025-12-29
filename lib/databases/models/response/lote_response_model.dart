// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/lote_cultura_response_model.dart';
import 'package:farmtracker/domains/models/lote_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lote_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoteResponseModel with EquatableMixin {
  final String uuid;
  final String nome;
  final String descricao;
  final List<LoteCulturaResponseModel> culturas;

  LoteResponseModel({
    required this.uuid,
    required this.nome,
    required this.descricao,
    required this.culturas,
  });

  @override
  List<Object> get props => [uuid, nome, descricao, culturas];

  LoteResponseModel copyWith({
    String? uuid,
    String? nome,
    String? descricao,
    List<LoteCulturaResponseModel>? culturas,
  }) {
    return LoteResponseModel(
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      culturas: culturas ?? this.culturas,
    );
  }

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$LoteResponseModelToJson(this);

  factory LoteResponseModel.fromJson(Map<String, dynamic> json) => _$LoteResponseModelFromJson(json);
}

extension LoteResponseModelMapper on LoteResponseModel {
  LoteModel toModel() {
    return LoteModel(
      uuid: uuid,
      nome: nome,
      descricao: descricao,
      culturas: culturas.map((cultura) => cultura.toModel()).toList(),
    );
  }
}

extension LoteResponseModelListMapper on List<LoteResponseModel> {
  List<LoteModel> toMapModel() {
    return map((lote) => lote.toModel()).toList();
  }
}
