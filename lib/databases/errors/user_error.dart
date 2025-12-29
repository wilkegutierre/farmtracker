import 'app_failure_interface.dart';

abstract class UserError extends AppFailure {
  final int? errorCode;

  UserError({this.errorCode, required super.message});
}

class LoginUserError extends UserError {
  LoginUserError({super.errorCode, super.message = "Falha no serviço de login!"});
}

class ClienteServiceError extends UserError {
  ClienteServiceError({super.errorCode, super.message = "Falha no serviço do cliente!"});
}

class ClienteRepositoryError extends UserError {
  ClienteRepositoryError({super.errorCode, super.message = "Falha no repositório do cliente!"});
}

class AgendaServiceError extends UserError {
  AgendaServiceError({super.errorCode, super.message = "Falha no serviço da agenda!"});
}

class CulturaServiceError extends UserError {
  CulturaServiceError({super.errorCode, super.message = "Falha no serviço de buscar culturas!"});
}

class MotivoAgendaServiceError extends UserError {
  MotivoAgendaServiceError({super.errorCode, super.message = "Falha no serviço aos buscar motivos da agenda!"});
}

class CulturaRepositoryError extends UserError {
  CulturaRepositoryError({super.errorCode, super.message = "Falha no repositório de cultura!"});
}
