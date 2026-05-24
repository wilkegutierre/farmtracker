import 'dart:convert';

import 'package:farmtracker/databases/mocks/models/cliente_response_model_mock.dart';
import 'package:farmtracker/databases/models/response/cliente_response_model.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

import '../../errors/user_error.dart';
import 'cliente_service.dart';

class ClienteServiceImpl with BaseServiceMixin implements ClienteService {
  final HttpClientInterface _httpClient;

  ClienteServiceImpl(this._httpClient);

  @override
  AsyncResult<ClienteResponseModel> getClientePorUuid(String uuid) async {
    try {
      return requestService(() async {
        return await _httpClient.get('${Enviroment.apiBaseUrl}/cliente/$uuid');
      }).fold(
        (response) {
          final Response(:body) = response;
          return Success(ClienteResponseModel.fromJson(json.decode(body)));
        },
        (failure) {
          return Failure(failure);
        },
      );
    } catch (error) {
      return Failure(ClienteServiceError(message: error.toString()));
    }
  }

  @override
  AsyncResult<List<ClienteResponseModel>> getClientes(String userUuid) async {
    try {
      return requestService(() async {
        return await _httpClient.get('${Enviroment.apiBaseUrl}/carteira/cliente/$userUuid');
      }).fold(
        (response) {
          final Response(:body) = response;
          if (kDebugMode) {
            print(body);
          }
          return Success(getMockClientes());
        },
        (failure) {
          return Failure(failure);
        },
      );
    } catch (error) {
      return Failure(ClienteServiceError(message: error.toString()));
    }
  }

  @override
  AsyncResult<ClienteResponseModel> syncClients(DateTime referenceDate) async {
    try {
      final result = await requestService(() async {
        final String dateParam = referenceDate.toString();
        final String url = '${Enviroment.apiBaseUrl}/customer/sync/$dateParam';
        return await _httpClient.get(url);
      });

      return result.fold(
        (response) async {
          final Response(:body) = response;
          if (kDebugMode) {
            print(body);
          }
          return Success(getMockCliente());
        },
        (failure) async => Failure(failure),
      );
    } catch (error) {
      return Failure(ClienteServiceError(message: error.toString()));
    }
  }
}
