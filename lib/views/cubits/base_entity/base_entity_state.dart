import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';

sealed class BaseEntityState extends Equatable {
  const BaseEntityState();

  @override
  List<Object?> get props => [];
}

final class BaseEntityInitial extends BaseEntityState {
  const BaseEntityInitial();
}

final class BaseEntityLoading extends BaseEntityState {
  const BaseEntityLoading();
}

final class BaseEntityListLoaded extends BaseEntityState {
  final List<BaseEntityResponseModel> baseEntities;

  const BaseEntityListLoaded(this.baseEntities);

  @override
  List<Object?> get props => [baseEntities];
}

final class BaseEntityLoaded extends BaseEntityState {
  final BaseEntityResponseModel baseEntity;

  const BaseEntityLoaded(this.baseEntity);

  @override
  List<Object?> get props => [baseEntity];
}

final class BaseEntityGravadoSucesso extends BaseEntityState {
  const BaseEntityGravadoSucesso();
}

final class BaseEntityAlteradoSucesso extends BaseEntityState {
  const BaseEntityAlteradoSucesso();
}

final class BaseEntityErro extends BaseEntityState {
  final String mensagem;

  const BaseEntityErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
