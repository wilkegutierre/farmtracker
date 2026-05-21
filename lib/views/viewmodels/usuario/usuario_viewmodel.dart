import 'package:farmtracker/databases/local/repositories/usuario_local_repository.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/domains/repositories/usuario/usuario_repository.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_data.dart';
import 'package:flutter/material.dart';

class UsuarioViewmodel extends ChangeNotifier {
  final UsuarioRepository usuarioRepository;
  final UsuarioLocalRepository usuarioLocalRepository;

  UsuarioViewmodel(this.usuarioRepository, this.usuarioLocalRepository);

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

  Future<String?> login(String acesso, String senha) async {
    usuarioData.isLoading = true;
    notifyListeners();
    final result = await usuarioRepository.login(LoginUserRequestModel(email: acesso, password: senha));
    final token = result.fold<String?>((success) => success, (failure) => null);

    if (token == null || token.isEmpty) {
      usuarioData.isLoading = false;
      notifyListeners();
      return null;
    }

    await usuarioLocalRepository.login(LoginUserRequestModel(email: acesso, password: senha));
    usuarioData.isLoading = false;
    notifyListeners();
    return token;
  }

  Future<String?> setPassword(String acesso, String senha) async {
    usuarioData.isLoading = true;
    notifyListeners();
    final result = await usuarioRepository.setPassword(LoginUserRequestModel(email: acesso, password: senha));
    return result.fold<String?>((success) => success, (failure) => null);
  }
}
