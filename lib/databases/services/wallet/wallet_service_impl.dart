import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/wallet_response_model.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/services/wallet/wallet_service.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class WalletServiceImpl with BaseServiceMixin implements WalletService {
  final HttpClientInterface _httpClient;

  WalletServiceImpl(this._httpClient);

  @override
  AsyncResult<List<WalletResponseModel>> getWalletsByUserId(String userId) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/wallets/owner/$userId';
        return await _httpClient.get(url);
      }).fold((success) {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        return Success(_parseWalletsFromBody(body));
      }, (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  List<WalletResponseModel> _parseWalletsFromBody(String body) {
    final dynamic decoded = json.decode(body);
    final List<dynamic> items;

    if (decoded is List) {
      items = decoded;
    } else if (decoded is Map<String, dynamic>) {
      final dynamic data = decoded['data'];
      if (data['content'] is List) {
        items = data['content'];
      } else {
        throw const FormatException('Resposta de wallets inválida.');
      }
    } else {
      throw const FormatException('Resposta de wallets inválida.');
    }

    return items.map((item) => WalletResponseModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
