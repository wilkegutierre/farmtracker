import 'dart:convert';

import 'package:equatable/equatable.dart';

class WalletModel with EquatableMixin {
  final String id;
  final String name;
  final String? description;
  final String? owner;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;

  WalletModel({
    required this.id,
    required this.name,
    this.description,
    this.owner,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  WalletModel copyWith({
    String? id,
    String? name,
    String? description,
    String? owner,
    String? createdAt,
    String? updatedAt,
    String? createdBy,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [id, name, description, owner, createdAt, updatedAt, createdBy];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'owner': owner,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
      };

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      owner: json['owner'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] as String?,
    );
  }
}
