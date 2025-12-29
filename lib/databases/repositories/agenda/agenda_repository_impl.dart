import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/request/agenda_request_model.dart';
import 'package:farmtracker/databases/models/response/agenda_response_model.dart';
import 'package:farmtracker/databases/services/agenda/agenda_service.dart';
import 'package:farmtracker/domains/repositories/agenda/agenda_repository.dart';
import 'package:result_dart/result_dart.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  final AgendaService service;

  AgendaRepositoryImpl(this.service);

  @override
  AsyncResult<AgendaResponseModel> createAgenda(AgendaRequestModel agendaRequest) async {
    try {
      return await service
          .createAgenda(agendaRequest)
          .fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<AgendaResponseModel> getAgendaById(String uuid) async {
    try {
      return await service.getAgendaById(uuid).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<List<AgendaResponseModel>> getAgendas(String userUuid) async {
    try {
      return await service.getAgendas(userUuid).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<AgendaResponseModel> updateAgenda(AgendaRequestModel agendaRequest) async {
    try {
      return await service
          .updateAgenda(agendaRequest)
          .fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }
}
