// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/lote_cultura_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lote_cultura_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LoteCulturaResponseModel with EquatableMixin {
  final String? loteId;
  final String culturaId;
  final double areaCultura;

  LoteCulturaResponseModel({this.loteId, required this.culturaId, required this.areaCultura});

  @override
  List<Object?> get props => [culturaId, areaCultura];

  @override
  bool? get stringify => true;

  LoteCulturaResponseModel copyWith({
    String? loteId,
    String? culturaId,
    double? areaCultura,
  }) {
    return LoteCulturaResponseModel(
      loteId: loteId ?? this.loteId,
      culturaId: culturaId ?? this.culturaId,
      areaCultura: areaCultura ?? this.areaCultura,
    );
  }

  Map<String, dynamic> toJson() => _$LoteCulturaResponseModelToJson(this);

  factory LoteCulturaResponseModel.fromJson(Map<String, dynamic> json) => _$LoteCulturaResponseModelFromJson(json);
}

extension LoteCulturaResponseModelMapper on LoteCulturaResponseModel {
  LoteCulturaModel toModel() {
    return LoteCulturaModel(
      lote: loteId ?? '',
      cultura: culturaId,
      areaCultura: areaCultura,
    );
  }
}
