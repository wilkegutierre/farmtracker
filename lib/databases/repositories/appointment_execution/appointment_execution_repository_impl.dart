import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/services/appointment_execution/appointment_execution_service.dart';
import 'package:farmtracker/domains/repositories/appointment_execution/appointment_execution_repository.dart';
import 'package:farmtracker/models/domain/appointment_execution_model.dart';
import 'package:result_dart/result_dart.dart';

class AppointmentExecutionRepositoryImpl implements AppointmentExecutionRepository {
  final AppointmentExecutionService service;

  AppointmentExecutionRepositoryImpl({required this.service});

  @override
  AsyncResult<List<AppointmentExecutionModel>> executions() async {
    try {
      return await service.executions().fold((success) => Success(success), (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<AppointmentExecutionModel> obterPorId(String id) async {
    try {
      return await service.obterPorId(id).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<AppointmentExecutionModel> obterPorAppointmentId(String appointmentId) async {
    try {
      return await service
          .obterPorAppointmentId(appointmentId)
          .fold((success) => Success(success), (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<bool> gravar(AppointmentExecutionModel execution) async {
    try {
      return await service.gravar(execution).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<bool> alterar(AppointmentExecutionModel execution) async {
    try {
      return await service.alterar(execution).fold((success) => Success(success), (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }
}
