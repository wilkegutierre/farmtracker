import 'package:farmtracker/core/session/session_storage.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/domains/models/auth_data.dart';
import 'package:farmtracker/databases/local/repositories/usuario_local_repository.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/domains/repositories/usuario/usuario_repository.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_data.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

class UsuarioViewmodel extends ChangeNotifier {
  final UsuarioRepository usuarioRepository;
  final UsuarioLocalRepository usuarioLocalRepository;
  final SessionManagerRepository sessionManagerRepository;

  UsuarioViewmodel(this.usuarioRepository, this.usuarioLocalRepository, this.sessionManagerRepository);

  final usuarioData = UsuarioData();

  Future<void> getUsuarioById(String id) async {
    final result = await usuarioRepository.getUsuarioById(id);
    result.fold(
      (success) {
        usuarioData.usuarioModel = success.toModel();
      },
      (failure) {
        // Handle failure
      },
    );
    notifyListeners();
  }

  Future<String?> login(String email, String senha) async {
    usuarioData.isLoading = true;
    notifyListeners();
    final result = await usuarioRepository.login(LoginUserRequestModel(null, email, password: senha));
    final AuthData? data = await result.fold((success) async {
      await sessionManagerRepository.saveSession(success);
      await SessionStorage.save(success.token, expiresAt: success.expiresAt);
      return success;
    }, (failure) => null);

    if (data == null || data.token.isEmpty) {
      usuarioData.isLoading = false;
      notifyListeners();
      return null;
    }

    await usuarioLocalRepository.login(LoginUserRequestModel(null, email, password: senha));
    usuarioData.isLoading = false;
    notifyListeners();
    return data.token;
  }

  Future<String?> setPassword(String email, String senha) async {
    usuarioData.isLoading = true;
    notifyListeners();
    await usuarioRepository
        .setPassword(LoginUserRequestModel(null, email, password: senha))
        .fold(
          (success) async {
            await sessionManagerRepository.saveSession(success);
            await SessionStorage.save(success.token, expiresAt: success.expiresAt);
            return success.token;
          },
          (error) {
            return null;
          },
        );

    // final result = await usuarioRepository.setPassword(LoginUserRequestModel(null, email, password: senha));
    // final AuthData? data = await result.fold(
    //   (success) async {
    //     await sessionManagerRepository.saveSession(success);
    //     await SessionStorage.save(success.token, expiresAt: success.expiresAt);
    //     return success;
    //   },
    //   (failure) {
    //     return null;
    //   },
    // );

    usuarioData.isLoading = false;
    notifyListeners();
    //return data?.token;
  }

  Future<bool> isSessionValid() async {
    return await sessionManagerRepository.isSessionValid();
  }
}
