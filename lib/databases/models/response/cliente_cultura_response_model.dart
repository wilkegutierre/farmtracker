import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cliente_cultura_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ClienteCulturaResponseModel with EquatableMixin {
  final String cliente;
  final String cultura;

  ClienteCulturaResponseModel({required this.cliente, required this.cultura});

  ClienteCulturaResponseModel copyWith({String? cliente, String? cultura}) {
    return ClienteCulturaResponseModel(cliente: cliente ?? this.cliente, cultura: cultura ?? this.cultura);
  }

  @override
  List<Object?> get props => [cliente, cultura];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$ClienteCulturaResponseModelToJson(this);

  factory ClienteCulturaResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ClienteCulturaResponseModelFromJson(json);
}
