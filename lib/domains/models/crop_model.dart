import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crop_model.g.dart';

@JsonSerializable(explicitToJson: true, ignoreUnannotated: true)
class CropModel with EquatableMixin {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'org_owner')
  final String orgOwner;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'created_by')
  final String? createdBy;

  CropModel({
    required this.id,
    required this.name,
    required this.orgOwner,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  CropModel copyWith({
    String? id,
    String? name,
    String? orgOwner,
    String? createdAt,
    String? updatedAt,
    String? createdBy,
  }) {
    return CropModel(
      id: id ?? this.id,
      name: name ?? this.name,
      orgOwner: orgOwner ?? this.orgOwner,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [id, name, orgOwner, createdAt, updatedAt, createdBy];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$CropModelToJson(this);

  factory CropModel.fromJson(Map<String, dynamic> json) => _$CropModelFromJson(json);
}
