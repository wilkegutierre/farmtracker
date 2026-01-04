// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_project_lot_culture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseProjectLotCultureModel _$ResponseProjectLotCultureModelFromJson(
  Map<String, dynamic> json,
) => ResponseProjectLotCultureModel(
  uuid: json['uuid'] as String,
  costumer: json['costumer'] as String,
  path: json['path'] as String,
  project: json['project'] as String,
  lot: json['lot'] as String,
  culture: json['culture'] as String,
  hectareCulture: (json['hectareCulture'] as num).toDouble(),
);

Map<String, dynamic> _$ResponseProjectLotCultureModelToJson(
  ResponseProjectLotCultureModel instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'costumer': instance.costumer,
  'path': instance.path,
  'project': instance.project,
  'lot': instance.lot,
  'culture': instance.culture,
  'hectareCulture': instance.hectareCulture,
};
