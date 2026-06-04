import 'dart:convert';

import 'package:equatable/equatable.dart';

class OrganizationResponseModel with EquatableMixin {
  final String id;
  final String? description;
  final String addressId;

  OrganizationResponseModel({
    required this.id,
    this.description,
    required this.addressId,
  });

  OrganizationResponseModel copyWith({
    String? id,
    String? description,
    String? addressId,
  }) {
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'address_id': addressId,
      };

  factory OrganizationResponseModel.fromJson(Map<String, dynamic> json) {
    return OrganizationResponseModel(
      id: json['id'] as String,
      description: json['description'] as String?,
      addressId: json['address_id'] as String,
    );
  }
}
