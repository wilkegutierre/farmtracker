import 'package:farmtracker/core/session/session_storage.dart';
import 'package:flutter/foundation.dart';

/// Estado global de autenticação: sessão persistida e expiração do token.
class AuthSessionController extends ChangeNotifier {
  bool _ready = false;
  bool _authenticated = false;

  bool get isReady => _ready;
  bool get isAuthenticated => _authenticated;

  /// Carrega o estado persistido (chamar ao abrir o app, antes de decidir a tela).
  Future<void> bootstrap() async {
    _authenticated = await SessionStorage.hasValidSession();
    _ready = true;
    notifyListeners();
  }

  /// Chamado após login bem-sucedido (token vindo da API ou refresh).
  Future<void> signIn(String accessToken, {DateTime? expiresAt}) async {
    _authenticated = true;
    notifyListeners();
  }

  Future<void> setToken(String accessToken, {DateTime? expiresAt}) async {
    await SessionStorage.save(accessToken, expiresAt: expiresAt);
  }

  /// Token inválido/expirado ou logout.
  Future<void> signOut() async {
    await SessionStorage.clear();
    _authenticated = false;
    notifyListeners();
  }

  /// Quando a API retornar 401 ou o refresh falhar.
  Future<void> onSessionExpired() => signOut();
}
