import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:farmtracker/databases/services/base_entity/base_entity_service.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class BaseEntityServiceImpl with BaseServiceMixin implements BaseEntityService {
  final HttpClientInterface _httpClient;

  BaseEntityServiceImpl(this._httpClient);

  @override
  AsyncResult<List<BaseEntityResponseModel>> getByOwnerId(String ownerId) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/base-entities/$ownerId';
        return await _httpClient.get(url);
      }).fold((success) {
        final Response(:body) = success;
        final dynamic decoded = json.decode(body);
        if (kDebugMode) {
          print(body);
        }
        if (decoded['data'] is List) {
          return Success(_parseBaseEntitiesFromBody(decoded));
        } else {
          return Success(List<BaseEntityResponseModel>.from([_parseBaseEntitie(decoded)]));
        }
      }, (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  List<BaseEntityResponseModel> _parseBaseEntitiesFromBody(dynamic decoded) {
    final List<dynamic> items;

    if (decoded is List) {
      items = decoded;
    } else if (decoded is Map<String, dynamic>) {
      if (decoded['success'] == false) return [];

      final dynamic data = decoded['data'];
      if (data is Map<String, dynamic> && data['content'] is List) {
        items = data['content'] as List<dynamic>;
      } else if (data is List) {
        items = data;
      } else {
        // TODO(): Refatorar
        //items = decoded['data'] as List<dynamic>;
        return [];
      }
    } else {
      throw const FormatException('Resposta de base entities inválida.');
    }

    if (items.isEmpty) return [];

    return items.map((item) => BaseEntityResponseModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  BaseEntityResponseModel _parseBaseEntitie(dynamic decoded) {
    if (decoded['data'] is Map<String, dynamic>) {
      return BaseEntityResponseModel.fromJson(decoded['data'] as Map<String, dynamic>);
    } else {
      throw const FormatException('Resposta de base entities inválida.');
    }
  }
}
