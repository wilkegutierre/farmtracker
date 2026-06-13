import 'package:farmtracker/models/domain/appointment_execution_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AppointmentExecutionRepository {
  AsyncResult<bool> gravar(AppointmentExecutionModel execution);
  AsyncResult<bool> alterar(AppointmentExecutionModel execution);
  AsyncResult<List<AppointmentExecutionModel>> executions();
  AsyncResult<AppointmentExecutionModel> obterPorId(String id);
  AsyncResult<AppointmentExecutionModel> obterPorAppointmentId(String appointmentId);
}
