import 'package:farmtracker/core/session/session_storage.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/databases/local/repositories/usuario_local_repository.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/domains/repositories/usuario/usuario_repository.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsuarioCubit extends Cubit<UsuarioState> {
  final UsuarioRepository _usuarioRepository;
  final UsuarioLocalRepository _usuarioLocalRepository;
  final SessionManagerRepository _sessionManagerRepository;

  UsuarioCubit(
    this._usuarioRepository,
    this._usuarioLocalRepository,
    this._sessionManagerRepository,
  ) : super(const UsuarioInitial());

  Future<void> login(String username, String senha) async {
    emit(const UsuarioLoading());

    final result = await _usuarioRepository.login(
      LoginUserRequestModel(username, null, password: senha),
    );

    final authData = await result.fold(
      (success) async {
        await _sessionManagerRepository.saveSession(success);
        await SessionStorage.save(success.token, expiresAt: success.expiresAt);
        return success;
      },
      (failure) => null,
    );

    if (authData == null || authData.token.isEmpty) {
      emit(const UsuarioLoginFailure('Não foi possível efetuar login. Verifique os dados.'));
      return;
    }

    await _usuarioLocalRepository.login(
      LoginUserRequestModel(username, null, password: senha),
    );

    emit(UsuarioLoginSuccess(authData.token));
  }

  Future<void> setPassword(String email, String senha) async {
    emit(const UsuarioLoading());

    bool success = false;

    final result = await _usuarioRepository.setPassword(
      LoginUserRequestModel(null, email, password: senha),
    );

    await result.fold(
      (data) async {
        await _sessionManagerRepository.saveSession(data);
        await SessionStorage.save(data.token, expiresAt: data.expiresAt);
        success = true;
      },
      (error) {},
    );

    if (success) {
      emit(const UsuarioPasswordSuccess());
    } else {
      emit(const UsuarioPasswordFailure('Não foi possível criar a senha. Verifique os dados informados.'));
    }
  }

  Future<void> getUsuarioById(String id) async {
    emit(const UsuarioLoading());

    final result = await _usuarioRepository.getUsuarioById(id);
    result.fold(
      (response) => emit(UsuarioLoaded(response.toModel())),
      (failure) => emit(const UsuarioLoginFailure('Erro ao buscar usuário.')),
    );
  }

  Future<bool> isSessionValid() => _sessionManagerRepository.isSessionValid();
}
