import 'dart:convert';

import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/mocks/models/cultura_response_model_mock.dart';
import 'package:farmtracker/databases/models/response/cultura_response_model.dart';
import 'package:farmtracker/databases/services/cultura/cultura_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/mocks/services/base_service_mock.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class CutluraServiceImpl with BaseServiceMockMixin implements CulturaService {
  final HttpClientInterface _httpClient;

  CutluraServiceImpl(this._httpClient);

  @override
  AsyncResult<List<CulturaResponseModel>> baixarCulturas(String cliente) async {
    try {
      return await requestServiceMock(() async {
        final url = '${Enviroment.apiBaseUrl}/culturas/$cliente';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          // Map<String, dynamic> element = jsonDecode(body);
          // List<CulturaResponseModel> culturasResult = [];
          // for (var item in element as List) {
          //   culturasResult.add(CulturaResponseModel.fromJson(item));
          // }
          //return Success(culturasResult);
          return Success(getMockCulturas());
        },
        (failure) {
          return Failure(failure);
        },
      );
    } catch (error) {
      return Failure(InternalServerError());
    }
  }
}
