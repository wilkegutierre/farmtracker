import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:farmtracker/databases/services/address/address_service.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class AddressServiceImpl with BaseServiceMixin implements AddressService {
  final HttpClientInterface _httpClient;

  AddressServiceImpl(this._httpClient);

  @override
  AsyncResult<List<AddressResponseModel>> getByOwner(String addressId) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/address/$addressId';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          if (kDebugMode) {
            print(body);
          }
          return Success(_parseAddressesFromBody(body));
        },
        (failure) {
          return Failure(failure);
        },
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return Failure(InternalServerError());
    }
  }

  List<AddressResponseModel> _parseAddressesFromBody(String body) {
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
        throw const FormatException('Resposta de addresses inválida.');
      }
    } else {
      throw const FormatException('Resposta de addresses inválida.');
    }

    if (items.isEmpty) return [];

    return items.map((item) => AddressResponseModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
