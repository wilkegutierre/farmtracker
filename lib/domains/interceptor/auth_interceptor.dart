import 'package:dio/dio.dart';
import 'package:farmtracker/databases/local/auth/auth_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authService = AuthService();

    // Bloqueia a requisição antes mesmo de sair do celular se o token estiver expirado
    if (!authService.isSessaoValida()) {
      // Cancela a requisição com um erro customizado
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Sessão expirada. Realize o login novamente.',
          type: DioExceptionType.cancel,
        ),
      );
    }

    // Se estiver válido, anexa o token automaticamente no cabeçalho
    options.headers['Authorization'] = 'Bearer ${authService.token}';
    return handler.next(options);
  }
}
