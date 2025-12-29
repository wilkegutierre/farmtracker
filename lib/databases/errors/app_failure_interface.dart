abstract class AppFailure implements Exception {
  final String message;
  final int? errorCode;

  AppFailure({required this.message, this.errorCode});
}

class InternetConnectionError extends AppFailure {
  InternetConnectionError({required super.message, super.errorCode});
}
