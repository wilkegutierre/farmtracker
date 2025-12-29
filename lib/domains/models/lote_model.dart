// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/lote_cultura_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lote_model.g.dart';

@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class LoteModel with EquatableMixin {
  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'projetoId')
  // TODO(): verificar se projeto pode ao ser NULL
  final String? projeto;
  @JsonKey(name: 'nome')
  final String nome;
  @JsonKey(name: 'descricao')
  final String descricao;
  final List<LoteCulturaModel>? culturas;

  LoteModel({required this.uuid, this.projeto, required this.nome, required this.descricao, this.culturas});

  @override
  List<Object> get props => [uuid, nome, descricao];

  LoteModel copyWith({
    String? uuid,
    String? projeto,
    String? nome,
    String? descricao,
    List<LoteCulturaModel>? culturas,
  }) {
    return LoteModel(
      uuid: uuid ?? this.uuid,
      projeto: projeto ?? this.projeto,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      culturas: culturas ?? this.culturas,
    );
  }

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$LoteModelToJson(this);

  factory LoteModel.fromJson(Map<String, dynamic> json) => _$LoteModelFromJson(json);
}
