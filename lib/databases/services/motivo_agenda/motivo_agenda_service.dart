import 'package:farmtracker/databases/models/response/motivo_agenda_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class MotivoAgendaService {
  AsyncResult<List<MotivoAgendaResponseModel>> getMotivos(String userUuid);
  AsyncResult<MotivoAgendaResponseModel> getMotivoById(String uuid);
}
