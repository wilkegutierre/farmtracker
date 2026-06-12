import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';

sealed class TypeVisitState extends Equatable {
  const TypeVisitState();

  @override
  List<Object?> get props => [];
}

final class TypeVisitInitial extends TypeVisitState {
  const TypeVisitInitial();
}

final class TypeVisitLoading extends TypeVisitState {
  const TypeVisitLoading();
}

final class TypeVisitListLoaded extends TypeVisitState {
  final List<TypeVisitResponseModel> typeVisits;

  const TypeVisitListLoaded(this.typeVisits);

  @override
  List<Object?> get props => [typeVisits];
}

final class TypeVisitLoaded extends TypeVisitState {
  final TypeVisitResponseModel typeVisit;

  const TypeVisitLoaded(this.typeVisit);

  @override
  List<Object?> get props => [typeVisit];
}

final class TypeVisitGravadoSucesso extends TypeVisitState {
  const TypeVisitGravadoSucesso();
}

final class TypeVisitAlteradoSucesso extends TypeVisitState {
  const TypeVisitAlteradoSucesso();
}

final class TypeVisitErro extends TypeVisitState {
  final String mensagem;

  const TypeVisitErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
