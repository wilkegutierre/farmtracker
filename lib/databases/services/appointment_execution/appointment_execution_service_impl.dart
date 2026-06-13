import 'package:farmtracker/databases/local/repositories/appointment_execution_local_repository.dart';
import 'package:farmtracker/databases/services/appointment_execution/appointment_execution_service.dart';
import 'package:farmtracker/models/domain/appointment_execution_model.dart';
import 'package:result_dart/result_dart.dart';

class AppointmentExecutionServiceImpl implements AppointmentExecutionService {
  final AppointmentExecutionLocalRepository _localRepository;

  AppointmentExecutionServiceImpl(this._localRepository);

  @override
  AsyncResult<List<AppointmentExecutionModel>> executions() {
    return _localRepository.executions();
  }

  @override
  AsyncResult<AppointmentExecutionModel> obterPorId(String id) {
    return _localRepository.obterPorId(id);
  }

  @override
  AsyncResult<AppointmentExecutionModel> obterPorAppointmentId(String appointmentId) {
    return _localRepository.obterPorAppointmentId(appointmentId);
  }

  @override
  AsyncResult<bool> gravar(AppointmentExecutionModel execution) {
    return _localRepository.gravar(execution);
  }

  @override
  AsyncResult<bool> alterar(AppointmentExecutionModel execution) {
    return _localRepository.alterar(execution);
  }
}
