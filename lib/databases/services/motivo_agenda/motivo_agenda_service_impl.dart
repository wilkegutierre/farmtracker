import 'dart:convert';

import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/mocks/models/motivo_agenda_response_model_mock.dart';
import 'package:farmtracker/databases/models/response/motivo_agenda_response_model.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/mocks/services/base_service_mock.dart';
import 'package:farmtracker/databases/services/motivo_agenda/motivo_agenda_service.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class MotivoAgendaServiceImpl with BaseServiceMockMixin implements MotivoAgendaService {
  final HttpClientInterface _httpClient;

  MotivoAgendaServiceImpl(this._httpClient);

  @override
  AsyncResult<MotivoAgendaResponseModel> getMotivoById(String uuid) async {
    try {
      return requestServiceMock(() async {
        final url = '${Enviroment.apiBaseUrl}/motivo-agenda/$uuid';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          //return Success(MotivoAgendaResponseModel.fromJson(json.decode(body)));
          return Success(mockMotivoAgendaResponseModel());
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
  AsyncResult<List<MotivoAgendaResponseModel>> getMotivos(String userUuid) async {
    try {
      return requestServiceMock(() async {
        final url = '${Enviroment.apiBaseUrl}/motivos-agenda/$userUuid';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          Map<String, dynamic> element = jsonDecode(body);
          List<MotivoAgendaResponseModel> motivosResult = [];
          for (var item in element as List) {
            motivosResult.add(MotivoAgendaResponseModel.fromJson(item));
          }
          return Success(mockMotivoAgendaModelList());
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
