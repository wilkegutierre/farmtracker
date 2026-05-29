import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/mocks/models/usuario_response_model_mock.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service.dart';
import 'package:farmtracker/domains/models/auth_data.dart';
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
  AsyncResult<AuthData> login(LoginUserRequestModel loginRequest) async {
    try {
      final result = await requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/user/auth/login';
        return await _httpClient.post(url, loginRequest.toJsonStringfy());
      });

      return result.fold((success) {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        return _mapAuthDataResult(body);
      }, (failure) => Failure(InternalServerError()));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<AuthData> setPassword(LoginUserRequestModel loginRequest) async {
    try {
      final result = await requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/user/auth/set-password';
        return await _httpClient.post(url, loginRequest.toJsonStringfy());
      });

      return result.fold(
        (success) {
          final Response(:body) = success;
          if (kDebugMode) {
            print(body);
          }
          return _mapAuthDataResult(body);
        },
        (failure) {
          return Failure(InternalServerError());
        },
      );
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  Result<AuthData> _mapAuthDataResult(String body) {
    try {
      return Success(_resolveAuthDataFromBody(body));
    } catch (_) {
      return Failure(InternalServerError(message: 'Resposta de autenticação inválida.'));
    }
  }

  AuthData _resolveAuthDataFromBody(String body) {
    final dynamic decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) {
      final token = decoded['data']['token'];
      final tokenType = decoded['data']['tokenType'] ?? 'Bearer';
      final expiresAtStr = decoded['data']['expiresAt'];

      if (token is String && token.isNotEmpty && expiresAtStr is String) {
        return AuthData(
          token: token,
          tokenType: tokenType,
          expiresAt: DateTime.parse(expiresAtStr).toLocal(), // Converte para o fuso horário do celular
        );
      }
    }
    throw FormatException('Corpo de autenticação inválido');
  }

  DateTime? _parseExpiresAt(Object? value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.parse(value).toLocal();
    }
    if (value is int) {
      if (value > 9999999999) {
        return DateTime.fromMillisecondsSinceEpoch(value).toLocal();
      }
      return DateTime.fromMillisecondsSinceEpoch(value * 1000).toLocal();
    }
    return null;
  }
}
