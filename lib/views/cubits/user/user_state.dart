import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/user_response_model.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserInitial extends UserState {
  const UserInitial();
}

final class UserLoading extends UserState {
  const UserLoading();
}

final class UserListLoaded extends UserState {
  final List<UserResponseModel> users;

  const UserListLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

final class UserLoaded extends UserState {
  final UserResponseModel user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

final class UserGravadoSucesso extends UserState {
  const UserGravadoSucesso();
}

final class UserAlteradoSucesso extends UserState {
  const UserAlteradoSucesso();
}

final class UserErro extends UserState {
  final String mensagem;

  const UserErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
