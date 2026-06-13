import 'package:farmtracker/domains/enums/appointment_status_enum.dart';
import 'package:farmtracker/databases/local/repositories/appointment_local_repository.dart';
import 'package:farmtracker/domains/repositories/appointment_execution/appointment_execution_repository.dart';
import 'package:farmtracker/models/domain/appointment_execution_model.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentLocalRepository _appointmentLocalRepository;
  final AppointmentExecutionRepository _appointmentExecutionRepository;

  List<AppointmentModel> _allAppointments = [];
  AppointmentModel? _appointmentEmExecucao;

  AppointmentCubit(this._appointmentLocalRepository, this._appointmentExecutionRepository)
    : super(const AppointmentInitial());

  List<AppointmentModel> get allAppointments => _allAppointments;
  AppointmentModel? get appointmentEmExecucao => _appointmentEmExecucao;

  Future<bool> selecionarParaExecucao(String appointmentId) async {
    final result = await _appointmentLocalRepository.obterPorId(appointmentId);
    return result.fold(
      (appointment) {
        _appointmentEmExecucao = appointment;
        return true;
      },
      (_) {
        _appointmentEmExecucao = null;
        return false;
      },
    );
  }

  void limparExecucao() {
    _appointmentEmExecucao = null;
  }

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

  Future<void> gravarExecucao(AppointmentExecutionModel execution) async {
    emit(const AppointmentLoading());

    final AppointmentModel? appointment = _appointmentEmExecucao;
    if (appointment == null) {
      emit(const AppointmentErro('Agendamento não encontrado para gravar execução.'));
      return;
    }

    final result = await _appointmentExecutionRepository.gravar(execution);
    final bool gravouExecucao = result.fold((value) => value, (_) => false);

    if (!gravouExecucao) {
      emit(const AppointmentErro('Falha ao gravar execução da visita.'));
      return;
    }

    final int novoStatus = execution.completed == 1
        ? AppointmentStatusEnum.realizado.value
        : AppointmentStatusEnum.cancelado.value;

    final AppointmentModel appointmentAtualizado = appointment.copyWith(status: novoStatus);
    final alterarResult = await _appointmentLocalRepository.alterar(appointmentAtualizado);
    final bool alterouAgendamento = alterarResult.fold((value) => value, (_) => false);

    if (!alterouAgendamento) {
      emit(const AppointmentErro('Falha ao atualizar status do agendamento.'));
      return;
    }

    _appointmentEmExecucao = null;
    await _recarregarTodosAppointments();
    emit(AppointmentExecucaoGravadaSucesso(visitaRealizada: execution.completed == 1));
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
