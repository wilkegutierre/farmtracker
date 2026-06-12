import 'package:farmtracker/databases/local/repositories/appointment_local_repository.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentLocalRepository _appointmentLocalRepository;

  List<AppointmentModel> _allAppointments = [];

  AppointmentCubit(this._appointmentLocalRepository) : super(const AppointmentInitial());

  List<AppointmentModel> get allAppointments => _allAppointments;

  Future<void> carregarAppointments() async {
    emit(const AppointmentLoading());

    final result = await _appointmentLocalRepository.appointments();
    result.fold((appointments) {
      _allAppointments = appointments;
      emit(AppointmentListLoaded(appointments));
    }, (_) => emit(const AppointmentErro('Falha ao carregar agendamentos.')));
  }

  Future<void> carregarAppointmentsPorData(DateTime date) async {
    emit(const AppointmentLoading());

    final result = await _appointmentLocalRepository.obterPorData(date);
    result.fold(
      (appointments) => emit(AppointmentDayLoaded(date: date, appointments: appointments)),
      (_) => emit(const AppointmentErro('Falha ao carregar agendamentos do dia.')),
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
    final bool success = result.fold((value) => value, (_) => false);

    if (!success) {
      emit(const AppointmentErro('Falha ao gravar agendamento.'));
      return;
    }

    await _recarregarTodosAppointments();

    final DateTime appointmentDate = DateTime.parse(appointment.datetime).toLocal();
    emit(
      AppointmentGravadoSucesso(
        appointmentDate: DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day),
      ),
    );
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

  Future<void> _recarregarTodosAppointments() async {
    final result = await _appointmentLocalRepository.appointments();
    result.fold((appointments) => _allAppointments = appointments, (_) {});
  }
}
