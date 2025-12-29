// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/lote_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'projeto_model.g.dart';

@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class ProjetoModel with EquatableMixin {
  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'clienteId')
  final String? clienteId;
  @JsonKey(name: 'nome')
  final String nome;
  @JsonKey(name: 'descricao')
  final String descricao;
  final List<LoteModel>? lotes;

  ProjetoModel({required this.uuid, this.clienteId, required this.nome, required this.descricao, this.lotes});

  @override
  List<Object> get props => [uuid, nome, descricao];

  ProjetoModel copyWith({String? uuid, String? clienteId, String? nome, String? descricao, List<LoteModel>? lotes}) {
    return ProjetoModel(
      uuid: uuid ?? this.uuid,
      clienteId: clienteId ?? this.clienteId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      lotes: lotes ?? this.lotes,
    );
  }

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$ProjetoModelToJson(this);

  factory ProjetoModel.fromJson(Map<String, dynamic> json) => _$ProjetoModelFromJson(json);
}
