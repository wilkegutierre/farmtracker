// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lote_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoteResponseModel _$LoteResponseModelFromJson(Map<String, dynamic> json) =>
    LoteResponseModel(
      uuid: json['uuid'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      culturas: (json['culturas'] as List<dynamic>)
          .map(
            (e) => LoteCulturaResponseModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$LoteResponseModelToJson(LoteResponseModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'culturas': instance.culturas.map((e) => e.toJson()).toList(),
    };
