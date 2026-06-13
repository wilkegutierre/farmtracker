import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/enum/sync_table_action.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/databases/services/customer/customer_service.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/domains/repositories/sync/sync_repository.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class CustomerServiceImpl with BaseServiceMixin implements CustomerService, SyncRepository {
  final HttpClientInterface _httpClient;

  CustomerServiceImpl(this._httpClient);

  @override
  AsyncResult<List<CustomerResponseModel>> getCustomersByWalletId(String walletId) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/customer/wallet/$walletId';
        return await _httpClient.get(url);
      }).fold((success) {
        final Response(:body) = success;
        if (kDebugMode) {
          print(body);
        }
        return Success(_parseCustomersFromBody(body));
      }, (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  List<CustomerResponseModel> _parseCustomersFromBody(String body) {
    final List<dynamic> items;
    final dynamic decoded = json.decode(body);
    if (decoded['success'] == false) return [];

    if (decoded['data']['content'] is List) {
      items = decoded['data']['content'];
      if (items.isEmpty) return [];
    } else if (decoded is Map<String, dynamic>) {
      final dynamic data = decoded['data'];
      if (data is List) {
        items = data;
      } else {
        throw const FormatException('Resposta de customers inválida.');
      }
    } else {
      throw const FormatException('Resposta de customers inválida.');
    }
    if (items.isEmpty) return [];
    return items.map((item) => CustomerResponseModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<AsyncResult<dynamic>> sendToServer({
    required String recordId,
    required SyncAction action,
    required Map<String, dynamic> payload,
  }) {
    // TODO: implement sendToServer
    throw UnimplementedError();
  }
}
