import 'package:farmtracker/core/session/auth_state.dart';
import 'package:farmtracker/core/session/session_storage.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final SessionManagerRepository _sessionManager;

  AuthCubit(this._sessionManager) : super(const AuthLoading()) {
    bootstrap();
  }

  Future<void> bootstrap() async {
    final bool sessionManagerValid = await _sessionManager.isSessionValid();
    final bool storageValid = await SessionStorage.hasValidSession();
    if (sessionManagerValid || storageValid) {
      emit(const AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signIn(String accessToken, {DateTime? expiresAt}) async {
    await SessionStorage.save(accessToken, expiresAt: expiresAt);
    emit(const AuthAuthenticated());
  }

  Future<void> setToken(String accessToken, {DateTime? expiresAt}) =>
      signIn(accessToken, expiresAt: expiresAt);

  Future<void> signOut() async {
    await SessionStorage.clear();
    await _sessionManager.clearSession();
    emit(const AuthUnauthenticated());
  }

  Future<void> onSessionExpired() => signOut();
}
