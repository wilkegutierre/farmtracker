import 'package:farmtracker/databases/models/response/motivo_agenda_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class MotivoAgendaLocalRepository {
  AsyncResult<bool> salvar(MotivoAgendaResponseModel motivoAgenda);
  AsyncResult<List<MotivoAgendaResponseModel>> motivosAgenda();
  AsyncResult<MotivoAgendaResponseModel> motivoAgenda(String uuid);
}
