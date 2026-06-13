import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/pest_response_model.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/services/pest/pest_service.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class PestServiceImpl with BaseServiceMixin implements PestService {
  final HttpClientInterface _httpClient;

  PestServiceImpl(this._httpClient);

  @override
  AsyncResult<List<PestResponseModel>> getByOrgOwner(String orgOwner) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/pests/org-owner/$orgOwner';
        return await _httpClient.get(url);
      }).fold((success) {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        return Success(_parsePestsFromBody(body));
      }, (failure) => Failure(failure));
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<PestResponseModel> getById(String id) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/pests/$id';
        return await _httpClient.get(url);
      }).fold((success) {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        return Success(_parsePestFromBody(body));
      }, (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  List<PestResponseModel> _parsePestsFromBody(String body) {
    final dynamic decoded = json.decode(body);
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
        return [];
      }
    } else {
      throw const FormatException('Resposta de pests inválida.');
    }

    if (items.isEmpty) return [];

    return items.map((item) => PestResponseModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  PestResponseModel _parsePestFromBody(String body) {
    final dynamic decoded = json.decode(body);

    if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is Map<String, dynamic>) {
        return PestResponseModel.fromJson(decoded['data'] as Map<String, dynamic>);
      }
      return PestResponseModel.fromJson(decoded);
    }

    throw const FormatException('Resposta de pest inválida.');
  }
}
