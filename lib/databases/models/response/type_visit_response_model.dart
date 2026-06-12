import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'type_visit_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TypeVisitResponseModel with EquatableMixin {
  final int id;
  final String description;
  final String orgOwner;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;

  TypeVisitResponseModel({
    required this.id,
    required this.description,
    required this.orgOwner,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  TypeVisitResponseModel copyWith({
    int? id,
    String? description,
    String? orgOwner,
    String? createdAt,
    String? updatedAt,
    String? createdBy,
  }) {
    return TypeVisitResponseModel(
      id: id ?? this.id,
      description: description ?? this.description,
      orgOwner: orgOwner ?? this.orgOwner,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [id, description, orgOwner, createdAt, updatedAt, createdBy];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$TypeVisitResponseModelToJson(this);

  factory TypeVisitResponseModel.fromJson(Map<String, dynamic> json) => _$TypeVisitResponseModelFromJson(json);
}
