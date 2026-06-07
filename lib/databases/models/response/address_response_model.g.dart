// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressResponseModel _$AddressResponseModelFromJson(
  Map<String, dynamic> json,
) => AddressResponseModel(
  id: json['id'] as String,
  orgOwner: json['orgOwner'] as String?,
  owner: json['owner'] as String?,
  street: json['street'] as String?,
  number: json['number'] as String?,
  district: json['district'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  uf: json['uf'] as String?,
  zipCode: json['zipCode'] as String?,
  country: json['country'] as String?,
  reference: json['reference'] as String?,
  complement: json['complement'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  createdBy: json['createdBy'] as String?,
);

Map<String, dynamic> _$AddressResponseModelToJson(
  AddressResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'orgOwner': instance.orgOwner,
  'owner': instance.owner,
  'street': instance.street,
  'number': instance.number,
  'district': instance.district,
  'city': instance.city,
  'state': instance.state,
  'uf': instance.uf,
  'zipCode': instance.zipCode,
  'country': instance.country,
  'reference': instance.reference,
  'complement': instance.complement,
  'lat': instance.lat,
  'longitude': instance.longitude,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'createdBy': instance.createdBy,
};
