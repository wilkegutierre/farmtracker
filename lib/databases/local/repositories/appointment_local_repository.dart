import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AppointmentLocalRepository {
  AsyncResult<bool> gravar(AppointmentModel appointment);
  AsyncResult<bool> alterar(AppointmentModel appointment);
  AsyncResult<List<AppointmentModel>> appointments();
  AsyncResult<AppointmentModel> obterPorId(String id);
}
