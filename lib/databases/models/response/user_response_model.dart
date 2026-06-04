import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserResponseModel with EquatableMixin {
  final String id;
  final String? email;
  final String? phone;
  final String? addressId;

  UserResponseModel({
    required this.id,
    this.email,
    this.phone,
    this.addressId,
  });

  UserResponseModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? addressId,
  }) {
    return UserResponseModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addressId: addressId ?? this.addressId,
    );
  }

  @override
  List<Object?> get props => [id, email, phone, addressId];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'address_id': addressId,
      };

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      addressId: json['address_id'] as String?,
    );
  }
}
