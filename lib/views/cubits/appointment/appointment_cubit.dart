import 'package:farmtracker/databases/local/repositories/appointment_local_repository.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentLocalRepository _appointmentLocalRepository;

  AppointmentCubit(this._appointmentLocalRepository) : super(const AppointmentInitial());

  Future<void> carregarAppointments() async {
    emit(const AppointmentLoading());

    final result = await _appointmentLocalRepository.appointments();
    result.fold(
      (appointments) => emit(AppointmentListLoaded(appointments)),
      (_) => emit(const AppointmentErro('Falha ao carregar agendamentos.')),
    );
  }

  Future<void> obterPorId(String id) async {
    emit(const AppointmentLoading());

    final result = await _appointmentLocalRepository.obterPorId(id);
    result.fold(
      (appointment) => emit(AppointmentLoaded(appointment)),
      (_) => emit(const AppointmentErro('Agendamento não encontrado.')),
    );
  }

  Future<void> gravar(AppointmentModel appointment) async {
    emit(const AppointmentLoading());

    final result = await _appointmentLocalRepository.gravar(appointment);
    result.fold((success) {
      if (success) {
        emit(const AppointmentGravadoSucesso());
      } else {
        emit(const AppointmentErro('Falha ao gravar agendamento.'));
      }
    }, (_) => emit(const AppointmentErro('Falha ao gravar agendamento.')));
  }

  Future<void> alterar(AppointmentModel appointment) async {
    emit(const AppointmentLoading());

    final result = await _appointmentLocalRepository.alterar(appointment);
    result.fold((success) {
      if (success) {
        emit(const AppointmentAlteradoSucesso());
      } else {
        emit(const AppointmentErro('Falha ao alterar agendamento.'));
      }
    }, (_) => emit(const AppointmentErro('Falha ao alterar agendamento.')));
  }
}
