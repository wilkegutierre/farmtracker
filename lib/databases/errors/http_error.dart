import 'app_failure_interface.dart';

abstract class HttpError extends AppFailure {
  final int statusCode;
  HttpError({required this.statusCode, required super.message});
}

HttpError getHttpError(int statusCode) {
  switch (statusCode) {
    case 401:
      return UnauthorizedError();
    case 503:
      return ServiceUnavailableError();
    default:
      return InternalServerError();
  }
}

class UnauthorizedError extends HttpError {
  UnauthorizedError({super.statusCode = 401, super.message = 'Acesso negado!'});
}

class InternalServerError extends HttpError {
  InternalServerError({super.statusCode = 500, super.message = 'Erro desconhecido!'});
}

class ServiceUnavailableError extends HttpError {
  ServiceUnavailableError(
      {super.statusCode = 503, super.message = 'Serviço indisponível no momento! Tente mais tarde.'});
}
