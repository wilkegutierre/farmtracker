import 'package:farmtracker/databases/local/repositories/base_entity_local_repository.dart';
import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:farmtracker/views/viewmodels/base_entity/base_entity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseEntityCubit extends Cubit<BaseEntityState> {
  final BaseEntityLocalRepository _baseEntityLocalRepository;

  BaseEntityCubit(this._baseEntityLocalRepository) : super(const BaseEntityInitial());

  Future<void> carregarBaseEntities() async {
    emit(const BaseEntityLoading());

    final result = await _baseEntityLocalRepository.baseEntities();
    result.fold(
      (baseEntities) => emit(BaseEntityListLoaded(baseEntities)),
      (_) => emit(const BaseEntityErro('Falha ao carregar base entities.')),
    );
  }

  Future<void> obterPorType(String type) async {
    emit(const BaseEntityLoading());

    final result = await _baseEntityLocalRepository.obterPorType(type);
    result.fold(
      (baseEntities) => emit(BaseEntityListLoaded(baseEntities)),
      (_) => emit(const BaseEntityErro('Falha ao buscar base entities por type.')),
    );
  }

  Future<void> obterPorId(String id) async {
    emit(const BaseEntityLoading());

    final result = await _baseEntityLocalRepository.obterPorId(id);
    result.fold(
      (baseEntity) => emit(BaseEntityLoaded(baseEntity)),
      (_) => emit(const BaseEntityErro('Base entity não encontrada.')),
    );
  }

  Future<void> obterPorDocNumber(String docNumber) async {
    emit(const BaseEntityLoading());

    final result = await _baseEntityLocalRepository.obterPorDocNumber(docNumber);
    result.fold(
      (baseEntity) => emit(BaseEntityLoaded(baseEntity)),
      (_) => emit(const BaseEntityErro('Base entity não encontrada.')),
    );
  }

  Future<void> gravar(BaseEntityResponseModel baseEntity) async {
    emit(const BaseEntityLoading());

    final result = await _baseEntityLocalRepository.gravar(baseEntity);
    result.fold(
      (success) {
        if (success) {
          emit(const BaseEntityGravadoSucesso());
        } else {
          emit(const BaseEntityErro('Falha ao gravar base entity.'));
        }
      },
      (_) => emit(const BaseEntityErro('Falha ao gravar base entity.')),
    );
  }

  Future<void> alterar(BaseEntityResponseModel baseEntity) async {
    emit(const BaseEntityLoading());

    final result = await _baseEntityLocalRepository.alterar(baseEntity);
    result.fold(
      (success) {
        if (success) {
          emit(const BaseEntityAlteradoSucesso());
        } else {
          emit(const BaseEntityErro('Falha ao alterar base entity.'));
        }
      },
      (_) => emit(const BaseEntityErro('Falha ao alterar base entity.')),
    );
  }
}
