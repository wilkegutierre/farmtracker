import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/usuario_model.dart';

sealed class UsuarioState extends Equatable {
  const UsuarioState();

  @override
  List<Object?> get props => [];
}

final class UsuarioInitial extends UsuarioState {
  const UsuarioInitial();
}

final class UsuarioLoading extends UsuarioState {
  const UsuarioLoading();
}

final class UsuarioLoginSuccess extends UsuarioState {
  final String token;
  const UsuarioLoginSuccess(this.token);

  @override
  List<Object?> get props => [token];
}

final class UsuarioLoginFailure extends UsuarioState {
  final String message;
  const UsuarioLoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class UsuarioPasswordSuccess extends UsuarioState {
  const UsuarioPasswordSuccess();
}

final class UsuarioPasswordFailure extends UsuarioState {
  final String message;
  const UsuarioPasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class UsuarioLoaded extends UsuarioState {
  final UsuarioModel usuario;
  const UsuarioLoaded(this.usuario);

  @override
  List<Object?> get props => [usuario];
}
