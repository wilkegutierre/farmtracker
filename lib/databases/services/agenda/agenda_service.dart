import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/models/request/agenda_request_model.dart';
import 'package:farmtracker/databases/models/response/agenda_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AgendaService {
  AsyncResult<List<AgendaResponseModel>> getAgendas(String userUuid);
  AsyncResult<AgendaResponseModel> getAgendaById(String uuid);
  AsyncResult<AgendaResponseModel> createAgenda(AgendaRequestModel agendaRequest);
  AsyncResult<AgendaResponseModel> updateAgenda(AgendaRequestModel agendaRequest);
}
