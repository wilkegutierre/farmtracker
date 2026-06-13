import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/pest_response_model.dart';

sealed class PestState extends Equatable {
  const PestState();

  @override
  List<Object?> get props => [];
}

final class PestInitial extends PestState {
  const PestInitial();
}

final class PestLoading extends PestState {
  const PestLoading();
}

final class PestListLoaded extends PestState {
  final List<PestResponseModel> pests;

  const PestListLoaded(this.pests);

  @override
  List<Object?> get props => [pests];
}

final class PestLoaded extends PestState {
  final PestResponseModel pest;

  const PestLoaded(this.pest);

  @override
  List<Object?> get props => [pest];
}

final class PestGravadoSucesso extends PestState {
  const PestGravadoSucesso();
}

final class PestAlteradoSucesso extends PestState {
  const PestAlteradoSucesso();
}

final class PestErro extends PestState {
  final String mensagem;

  const PestErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
