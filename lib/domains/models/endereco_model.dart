import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'endereco_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EnderecoModel with EquatableMixin {
  final String uuid;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;
  final String cep;
  final int numero;
  final String complemento;
  final int principal;
  final String pessoa;

  EnderecoModel({
    required this.uuid,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.cep,
    required this.numero,
    required this.complemento,
    required this.principal,
    required this.pessoa,
  });

  EnderecoModel copyWith({
    String? uuid,
    String? logradouro,
    String? bairro,
    String? cidade,
    String? uf,
    String? cep,
    int? numero,
    String? complemento,
    int? principal,
    String? pessoa,
  }) {
    return EnderecoModel(
      uuid: uuid ?? this.uuid,
      logradouro: logradouro ?? this.logradouro,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      principal: principal ?? this.principal,
      pessoa: pessoa ?? this.pessoa,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        logradouro,
        bairro,
        cidade,
        uf,
        cep,
        numero,
        complemento,
        principal,
        pessoa,
      ];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$EnderecoModelToJson(this);

  factory EnderecoModel.fromJson(Map<String, dynamic> json) => _$EnderecoModelFromJson(json);
}
