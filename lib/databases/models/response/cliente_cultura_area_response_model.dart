import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cliente_cultura_area_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClienteCulturaAreaResponseModel with EquatableMixin {
  final String cliente;
  final String cultura;
  final double area;

  ClienteCulturaAreaResponseModel({required this.cliente, required this.cultura, required this.area});

  ClienteCulturaAreaResponseModel copyWith({
    String? cliente,
    String? cultura,
    double? area,
  }) {
    return ClienteCulturaAreaResponseModel(
      cliente: cliente ?? this.cliente,
      cultura: cultura ?? this.cultura,
      area: area ?? this.area,
    );
  }

  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$ClienteCulturaAreaResponseModelToJson(this);

  factory ClienteCulturaAreaResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ClienteCulturaAreaResponseModelFromJson(json);
}
