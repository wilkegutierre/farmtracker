import 'dart:convert';

import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/request/agenda_request_model.dart';
import 'package:farmtracker/databases/models/response/agenda_response_model.dart';
import 'package:farmtracker/databases/services/agenda/agenda_service.dart';
import 'package:farmtracker/databases/services/http/base_service.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

class AgendaServiceImpl with BaseServiceMixin implements AgendaService {
  final HttpClientInterface _httpClient;

  AgendaServiceImpl(this._httpClient);

  @override
  AsyncResult<AgendaResponseModel> createAgenda(AgendaRequestModel agendaRequest) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/agenda';
        return await _httpClient.post(url, agendaRequest.toJsonStringfy());
      }).fold(
        (success) {
          final Response(:body) = success;
          return Success(AgendaResponseModel.fromJson(json.decode(body)));
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
  AsyncResult<AgendaResponseModel> getAgendaById(String uuid) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/agenda/$uuid';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          return Success(AgendaResponseModel.fromJson(json.decode(body)));
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
  AsyncResult<List<AgendaResponseModel>> getAgendas(String userUuid) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/agendas/$userUuid';
        return await _httpClient.get(url);
      }).fold(
        (success) {
          final Response(:body) = success;
          Map<String, dynamic> element = jsonDecode(body);
          List<AgendaResponseModel> agendasResult = [];
          for (var item in element as List) {
            agendasResult.add(AgendaResponseModel.fromJson(item));
          }
          return Success(agendasResult);
        },
        (failure) {
          return Failure(failure);
        },
      );
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<AgendaResponseModel> updateAgenda(AgendaRequestModel agendaRequest) async {
    try {
      return requestService(() async {
        final url = '${Enviroment.apiBaseUrl}/agenda/${agendaRequest.uuid}';
        return await _httpClient.put(url, agendaRequest.toJsonStringfy());
      }).fold(
        (success) {
          final Response(:body) = success;
          return Success(AgendaResponseModel.fromJson(json.decode(body)));
        },
        (failure) {
          return Failure(InternalServerError());
        },
      );
    } catch (e) {
      return Failure(InternalServerError());
    }
  }
}
