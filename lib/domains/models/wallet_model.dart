import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletModel with EquatableMixin {
  final String id;
  final String name;

  WalletModel({required this.id, required this.name});

  WalletModel copyWith({String? id, String? name}) {
    return WalletModel(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$WalletModelToJson(this);

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);
}
