import 'package:farmtracker/databases/local/repositories/user_local_repository.dart';
import 'package:farmtracker/databases/models/response/user_response_model.dart';
import 'package:farmtracker/views/cubits/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final UserLocalRepository _userLocalRepository;

  UserCubit(this._userLocalRepository) : super(const UserInitial());

  Future<void> carregarUsers() async {
    emit(const UserLoading());

    final result = await _userLocalRepository.users();
    result.fold((users) => emit(UserListLoaded(users)), (_) => emit(const UserErro('Falha ao carregar users.')));
  }

  Future<void> obterPorAddressId(String addressId) async {
    emit(const UserLoading());

    final result = await _userLocalRepository.obterPorAddressId(addressId);
    result.fold(
      (users) => emit(UserListLoaded(users)),
      (_) => emit(const UserErro('Falha ao buscar users por address_id.')),
    );
  }

  Future<void> obterPorId(String id) async {
    emit(const UserLoading());

    final result = await _userLocalRepository.obterPorId(id);
    result.fold((user) => emit(UserLoaded(user)), (_) => emit(const UserErro('User não encontrado.')));
  }

  Future<void> obterPorEmail(String email) async {
    emit(const UserLoading());

    final result = await _userLocalRepository.obterPorEmail(email);
    result.fold((user) => emit(UserLoaded(user)), (_) => emit(const UserErro('User não encontrado.')));
  }

  Future<void> gravar(UserResponseModel user) async {
    emit(const UserLoading());

    final result = await _userLocalRepository.gravar(user);
    result.fold((success) {
      if (success) {
        emit(const UserGravadoSucesso());
      } else {
        emit(const UserErro('Falha ao gravar user.'));
      }
    }, (_) => emit(const UserErro('Falha ao gravar user.')));
  }

  Future<void> alterar(UserResponseModel user) async {
    emit(const UserLoading());

    final result = await _userLocalRepository.alterar(user);
    result.fold((success) {
      if (success) {
        emit(const UserAlteradoSucesso());
      } else {
        emit(const UserErro('Falha ao alterar user.'));
      }
    }, (_) => emit(const UserErro('Falha ao alterar user.')));
  }
}
