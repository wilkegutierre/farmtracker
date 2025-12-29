// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endereco_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnderecoModel _$EnderecoModelFromJson(Map<String, dynamic> json) =>
    EnderecoModel(
      uuid: json['uuid'] as String,
      logradouro: json['logradouro'] as String,
      bairro: json['bairro'] as String,
      cidade: json['cidade'] as String,
      uf: json['uf'] as String,
      cep: json['cep'] as String,
      numero: (json['numero'] as num).toInt(),
      complemento: json['complemento'] as String,
      principal: (json['principal'] as num).toInt(),
      pessoa: json['pessoa'] as String,
    );

Map<String, dynamic> _$EnderecoModelToJson(EnderecoModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'logradouro': instance.logradouro,
      'bairro': instance.bairro,
      'cidade': instance.cidade,
      'uf': instance.uf,
      'cep': instance.cep,
      'numero': instance.numero,
      'complemento': instance.complemento,
      'principal': instance.principal,
      'pessoa': instance.pessoa,
    };
