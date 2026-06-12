import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/services/type_visit/type_visit_service.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class TypeVisitServiceImpl with BaseServiceMixin implements TypeVisitService {
  final HttpClientInterface _httpClient;

  TypeVisitServiceImpl(this._httpClient);

  @override
  AsyncResult<List<TypeVisitResponseModel>> getByOrgOwner(String orgOwner) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/type-visits/org-owner/$orgOwner';
        return await _httpClient.get(url);
      }).fold((success) {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        return Success(_parseTypeVisitsFromBody(body));
      }, (failure) => Failure(failure));
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<TypeVisitResponseModel> getById(int id) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/type-visits/$id';
        return await _httpClient.get(url);
      }).fold((success) {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        return Success(_parseTypeVisitFromBody(body));
      }, (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  List<TypeVisitResponseModel> _parseTypeVisitsFromBody(String body) {
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
      throw const FormatException('Resposta de type visits inválida.');
    }

    if (items.isEmpty) return [];

    return items.map((item) => TypeVisitResponseModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  TypeVisitResponseModel _parseTypeVisitFromBody(String body) {
    final dynamic decoded = json.decode(body);

    if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is Map<String, dynamic>) {
        return TypeVisitResponseModel.fromJson(decoded['data'] as Map<String, dynamic>);
      }
      return TypeVisitResponseModel.fromJson(decoded);
    }

    throw const FormatException('Resposta de type visit inválida.');
  }
}
