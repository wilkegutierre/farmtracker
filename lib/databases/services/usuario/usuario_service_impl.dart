import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/mocks/models/usuario_response_model_mock.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class UsuarioServiceImpl with BaseServiceMixin implements UsuarioService {
  final HttpClientInterface _httpClient;

  UsuarioServiceImpl(this._httpClient);

  @override
  AsyncResult<UsuarioResponseModel> getUsuarioById(String uuid) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/usuario/$uuid';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          if (kDebugMode) {
            print(body);
          }
          //return Success(UsuarioResponseModel.fromJson(json.decode(bodyMock)));
          return Success(getMockUsuario());
        },
        (failure) {
          return Failure(InternalServerError());
        },
      );
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<String> login(LoginUserRequestModel loginRequest) async {
    try {
      final result = await requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/user/auth/login';
        return await _httpClient.post(url, loginRequest.toJsonStringfy());
      });

      return result.fold((success) async {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        final String token = _resolveTokenFromBody(body);
        return Success(token);
      }, (failure) async => Failure(InternalServerError()));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<String> setPassword(LoginUserRequestModel loginRequest) async {
    try {
      final result = await requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/user/auth/set-password';
        return await _httpClient.post(url, loginRequest.toJsonStringfy());
      });

      return result.fold((success) async {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        final String token = _resolveTokenFromBody(body);
        return Success(token);
      }, (failure) async => Failure(InternalServerError()));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  String _resolveTokenFromBody(String body) {
    final dynamic decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) {
      final Object? token = decoded['token'];
      if (token is String && token.isNotEmpty) {
        return token;
      }
    }
    return getMockUsuario().tokenAcesso;
  }
}
