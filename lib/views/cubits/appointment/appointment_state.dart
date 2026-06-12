import 'package:equatable/equatable.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';

sealed class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

final class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

final class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

final class AppointmentListLoaded extends AppointmentState {
  final List<AppointmentModel> appointments;

  const AppointmentListLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

final class AppointmentDayLoaded extends AppointmentState {
  final DateTime date;
  final List<AppointmentModel> appointments;

  const AppointmentDayLoaded({required this.date, required this.appointments});

  @override
  List<Object?> get props => [date, appointments];
}

final class AppointmentLoaded extends AppointmentState {
  final AppointmentModel appointment;

  const AppointmentLoaded(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

final class AppointmentGravadoSucesso extends AppointmentState {
  final DateTime appointmentDate;

  const AppointmentGravadoSucesso({required this.appointmentDate});

  @override
  List<Object?> get props => [appointmentDate];
}

final class AppointmentAlteradoSucesso extends AppointmentState {
  const AppointmentAlteradoSucesso();
}

final class AppointmentErro extends AppointmentState {
  final String mensagem;

  const AppointmentErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
