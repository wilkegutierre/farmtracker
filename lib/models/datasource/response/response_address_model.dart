import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseAddressModel with EquatableMixin {
  final String uuid;
  final String owner;
  final String street;
  final String number;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final String supplement;
  final String referencePoint;

  ResponseAddressModel({
    required this.uuid,
    required this.owner,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.supplement,
    required this.referencePoint,
  });

  ResponseAddressModel copyWith({
    String? uuid,
    String? owner,
    String? street,
    String? number,
    String? neighborhood,
    String? city,
    String? state,
    String? zipCode,
    String? supplement,
    String? referencePoint,
  }) {
    return ResponseAddressModel(
      uuid: uuid ?? this.uuid,
      owner: owner ?? this.owner,
      street: street ?? this.street,
      number: number ?? this.number,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      supplement: supplement ?? this.supplement,
      referencePoint: referencePoint ?? this.referencePoint,
    );
  }

  @override
  List<Object?> get props => [
    uuid,
    owner,
    street,
    number,
    neighborhood,
    city,
    state,
    zipCode,
    supplement,
    referencePoint,
  ];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => _$ResponseAddressModelToJson(this);

  factory ResponseAddressModel.fromJson(Map<String, dynamic> json) => _$ResponseAddressModelFromJson(json);

  String toJsonStringfy() => json.encode(toJson());
}
