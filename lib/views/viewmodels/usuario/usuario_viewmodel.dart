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

  Future<void> login(String acesso, String senha) async {
    usuarioData.isLoading = true;
    final result = await usuarioRepository.login(LoginUserRequestModel(acesso: acesso, senha: senha));
    await result.fold(
      (success) async {
        await usuarioLocalRepository.gravarUsuario(success.toModel()).then((_) {
          usuarioData.usuarioModel = success.toModel();
        });
        usuarioData.isLoading = false;
      },
      (failure) {
        // Handle failure
      },
    );
    notifyListeners();
  }
}
