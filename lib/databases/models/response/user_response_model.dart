import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserResponseModel with EquatableMixin {
  final String id;
  final String? email;
  final String? phone;
  final String? addressId;

  UserResponseModel({required this.id, this.email, this.phone, this.addressId});

  UserResponseModel copyWith({String? id, String? email, String? phone, String? addressId}) {
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

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);

  factory UserResponseModel.fromJson(Map<String, dynamic> json) => _$UserResponseModelFromJson(json);
}
