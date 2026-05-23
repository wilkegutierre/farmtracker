import 'package:farmtracker/core/session/auth_session_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Redireciona para o shell de autenticação após expiração ou logout forçado.
Future<void> redirectToLoginOnSessionExpired() async {
  final AuthSessionController auth = Modular.get<AuthSessionController>();
  await auth.onSessionExpired();
  Modular.to.navigate('/');
}
