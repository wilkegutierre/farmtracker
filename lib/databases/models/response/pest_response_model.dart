import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pest_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PestResponseModel with EquatableMixin {
  final String id;
  final String name;
  final String description;
  final String orgOwner;

  PestResponseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.orgOwner,
  });

  PestResponseModel copyWith({
    String? id,
    String? name,
    String? description,
    String? orgOwner,
  }) {
    return PestResponseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      orgOwner: orgOwner ?? this.orgOwner,
    );
  }

  @override
  List<Object?> get props => [id, name, description, orgOwner];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$PestResponseModelToJson(this);

  factory PestResponseModel.fromJson(Map<String, dynamic> json) => _$PestResponseModelFromJson(json);
}
