import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cliente_cultura_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClienteCulturaModel with EquatableMixin {
  final String cliente;
  final String cultura;
  final double area;
  final String lote;
  final String projeto;

  ClienteCulturaModel({
    required this.cliente,
    required this.cultura,
    required this.area,
    required this.projeto,
    required this.lote,
  });

  ClienteCulturaModel copyWith({
    String? cliente,
    String? cultura,
    double? area,
    String? projeto,
    String? lote,
  }) {
    return ClienteCulturaModel(
      cliente: cliente ?? this.cliente,
      cultura: cultura ?? this.cultura,
      area: area ?? this.area,
      projeto: projeto ?? this.projeto,
      lote: lote ?? this.lote,
    );
  }

  @override
  List<Object?> get props => [cliente, cultura, area, projeto, lote];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$ClienteCulturaModelToJson(this);

  factory ClienteCulturaModel.fromJson(Map<String, dynamic> json) => _$ClienteCulturaModelFromJson(json);
}
