import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletResponseModel with EquatableMixin {
  final String id;
  final String name;
  final String? description;

  WalletResponseModel({required this.id, required this.name, this.description});

  WalletResponseModel copyWith({String? id, String? name, String? description}) {
    return WalletResponseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, description];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$WalletResponseModelToJson(this);

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) => _$WalletResponseModelFromJson(json);
}
