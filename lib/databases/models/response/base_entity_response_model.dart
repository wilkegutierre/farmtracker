import 'dart:convert';

import 'package:equatable/equatable.dart';

class BaseEntityResponseModel with EquatableMixin {
  final String id;
  final String orgOwner;
  final String? name;
  final String? type;
  final String? docNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;

  BaseEntityResponseModel({
    required this.id,
    required this.orgOwner,
    this.name,
    this.type,
    this.docNumber,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  BaseEntityResponseModel copyWith({
    String? id,
    String? orgOwner,
    String? name,
    String? type,
    String? docNumber,
    String? createdAt,
    String? updatedAt,
    String? createdBy,
  }) {
    return BaseEntityResponseModel(
      id: id ?? this.id,
      orgOwner: orgOwner ?? this.orgOwner,
      name: name ?? this.name,
      type: type ?? this.type,
      docNumber: docNumber ?? this.docNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [id, orgOwner, name, type, docNumber, createdAt, updatedAt, createdBy];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'id': id,
        'org_owner': orgOwner,
        'name': name,
        'type': type,
        'doc_number': docNumber,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
      };

  factory BaseEntityResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseEntityResponseModel(
      id: json['id'] as String,
      orgOwner: json['org_owner'] as String,
      name: json['name'] as String?,
      type: json['type'] as String?,
      docNumber: json['doc_number'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] as String?,
    );
  }
}
