import 'package:farmtracker/core/session/session_storage.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Estado global de autenticação: sessão persistida e expiração do token.
class AuthSessionController extends ChangeNotifier {
  final SessionManagerRepository _sessionManager;

  AuthSessionController(this._sessionManager);

  bool _ready = false;
  bool _authenticated = false;

  bool get isReady => _ready;
  bool get isAuthenticated => _authenticated;

  /// Carrega o estado persistido (chamar ao abrir o app, antes de decidir a tela).
  Future<void> bootstrap() async {
    final bool sessionManagerValid = await _sessionManager.isSessionValid();
    final bool storageValid = await SessionStorage.hasValidSession();
    _authenticated = sessionManagerValid || storageValid;
    _ready = true;
    notifyListeners();

    if (_authenticated) {
      Modular.to.navigate('/home');
    }
  }

  /// Chamado após login bem-sucedido (token vindo da API ou refresh).
  Future<void> signIn(String accessToken, {DateTime? expiresAt}) async {
    await SessionStorage.save(accessToken, expiresAt: expiresAt);
    _authenticated = true;
    notifyListeners();
  }

  Future<void> setToken(String accessToken, {DateTime? expiresAt}) async {
    await signIn(accessToken, expiresAt: expiresAt);
  }

  /// Token inválido/expirado ou logout.
  Future<void> signOut() async {
    await SessionStorage.clear();
    await _sessionManager.clearSession();
    _authenticated = false;
    notifyListeners();
  }

  /// Quando a API retornar 401 ou o refresh falhar.
  Future<void> onSessionExpired() => signOut();
}
