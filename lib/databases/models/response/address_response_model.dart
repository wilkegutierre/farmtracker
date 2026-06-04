import 'dart:convert';

import 'package:equatable/equatable.dart';

class AddressResponseModel with EquatableMixin {
  final String id;
  final String? orgOwner;
  final String? owner;
  final String? street;
  final String? number;
  final String? district;
  final String? city;
  final String? state;
  final String? uf;
  final String? zipCode;
  final String? country;
  final String? reference;
  final String? complement;
  final double? lat;
  final double? longitude;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;

  AddressResponseModel({
    required this.id,
    this.orgOwner,
    this.owner,
    this.street,
    this.number,
    this.district,
    this.city,
    this.state,
    this.uf,
    this.zipCode,
    this.country,
    this.reference,
    this.complement,
    this.lat,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  AddressResponseModel copyWith({
    String? id,
    String? orgOwner,
    String? owner,
    String? street,
    String? number,
    String? district,
    String? city,
    String? state,
    String? uf,
    String? zipCode,
    String? country,
    String? reference,
    String? complement,
    double? lat,
    double? longitude,
    String? createdAt,
    String? updatedAt,
    String? createdBy,
  }) {
    return AddressResponseModel(
      id: id ?? this.id,
      orgOwner: orgOwner ?? this.orgOwner,
      owner: owner ?? this.owner,
      street: street ?? this.street,
      number: number ?? this.number,
      district: district ?? this.district,
      city: city ?? this.city,
      state: state ?? this.state,
      uf: uf ?? this.uf,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      reference: reference ?? this.reference,
      complement: complement ?? this.complement,
      lat: lat ?? this.lat,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orgOwner,
        owner,
        street,
        number,
        district,
        city,
        state,
        uf,
        zipCode,
        country,
        reference,
        complement,
        lat,
        longitude,
        createdAt,
        updatedAt,
        createdBy,
      ];

  @override
  bool? get stringify => true;

  String toJsonStringfy() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'id': id,
        'org_owner': orgOwner,
        'owner': owner,
        'street': street,
        'number': number,
        'district': district,
        'city': city,
        'state': state,
        'uf': uf,
        'zip_code': zipCode,
        'country': country,
        'reference': reference,
        'complement': complement,
        'lat': lat,
        'longitude': longitude,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
      };

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressResponseModel(
      id: json['id'] as String,
      orgOwner: json['org_owner'] as String?,
      owner: json['owner'] as String?,
      street: json['street'] as String?,
      number: json['number'] as String?,
      district: json['district'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      uf: json['uf'] as String?,
      zipCode: json['zip_code'] as String?,
      country: json['country'] as String?,
      reference: json['reference'] as String?,
      complement: json['complement'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] as String?,
    );
  }
}
