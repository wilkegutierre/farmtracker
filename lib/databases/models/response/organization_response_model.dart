import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'organization_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrganizationResponseModel with EquatableMixin {
  final String id;
  final String? description;
  final String addressId;

  OrganizationResponseModel({required this.id, this.description, required this.addressId});

  OrganizationResponseModel copyWith({String? id, String? description, String? addressId}) {
    return OrganizationResponseModel(
      id: id ?? this.id,
      description: description ?? this.description,
      addressId: addressId ?? this.addressId,
    );
  }

  @override
  List<Object?> get props => [id, description, addressId];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => _$OrganizationResponseModelToJson(this);

  factory OrganizationResponseModel.fromJson(Map<String, dynamic> json) => _$OrganizationResponseModelFromJson(json);
}
