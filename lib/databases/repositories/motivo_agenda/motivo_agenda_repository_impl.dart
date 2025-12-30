import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/motivo_agenda_response_model.dart';
import 'package:farmtracker/databases/services/motivo_agenda/motivo_agenda_service.dart';
import 'package:farmtracker/domains/repositories/motivo_agenda/motivo_agenda_repository.dart';
import 'package:result_dart/result_dart.dart';

class MotivoAgendaRepositoryImpl implements MotivoAgendaRepository {
  final MotivoAgendaService service;

  MotivoAgendaRepositoryImpl(this.service);
  @override
  AsyncResult<MotivoAgendaResponseModel> getMotivoById(String uuid) async {
    try {
      return await service.getMotivoById(uuid).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<List<MotivoAgendaResponseModel>> getMotivos(String userUuid) async {
    try {
      return await service.getMotivos(userUuid).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternalServerError());
    }
  }
}
