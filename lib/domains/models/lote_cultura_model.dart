// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lote_cultura_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoteCulturaModel with EquatableMixin {
  @JsonKey(name: 'loteId')
  final String lote;
  @JsonKey(name: 'culturaId')
  final String cultura;
  @JsonKey(name: 'areaCultura')
  final double areaCultura;

  LoteCulturaModel({required this.lote, required this.cultura, required this.areaCultura});

  @override
  List<Object> get props => [lote, cultura, areaCultura];

  LoteCulturaModel copyWith({
    String? lote,
    String? cultura,
    double? areaCultura,
  }) {
    return LoteCulturaModel(
      lote: lote ?? this.lote,
      cultura: cultura ?? this.cultura,
      areaCultura: areaCultura ?? this.areaCultura,
    );
  }

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$LoteCulturaModelToJson(this);

  factory LoteCulturaModel.fromJson(Map<String, dynamic> json) => _$LoteCulturaModelFromJson(json);
}
