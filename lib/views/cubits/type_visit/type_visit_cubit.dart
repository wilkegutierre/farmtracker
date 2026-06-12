import 'package:farmtracker/databases/local/repositories/type_visit_local_repository.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:farmtracker/domains/repositories/type_visit/type_visit_repository.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeVisitCubit extends Cubit<TypeVisitState> {
  final TypeVisitRepository _typeVisitRepository;
  final TypeVisitLocalRepository _typeVisitLocalRepository;

  TypeVisitCubit(this._typeVisitRepository, this._typeVisitLocalRepository) : super(const TypeVisitInitial());

  Future<void> syncTypeVisits(String orgOwner) async {
    emit(const TypeVisitLoading());

    final result = await _typeVisitRepository.getByOrgOwner(orgOwner);
    final List<TypeVisitResponseModel>? typeVisits = result.fold((success) => success, (_) => null);

    if (typeVisits == null) {
      emit(const TypeVisitErro('Falha ao carregar tipos de visita da API.'));
      return;
    }

    if (typeVisits.isNotEmpty) {
      final bool saved = await _persistTypeVisitsLocally(typeVisits);
      if (!saved) {
        emit(const TypeVisitErro('Falha ao gravar tipos de visita localmente.'));
        return;
      }
    }

    emit(TypeVisitListLoaded(typeVisits));
  }

  Future<void> syncTypeVisitsByCustomers(String orgOwner) async {
    emit(const TypeVisitLoading());

    final result = await _typeVisitRepository.getByOrgOwner(orgOwner);
    final List<TypeVisitResponseModel>? typeVisits = result.fold((success) => success, (_) => null);

    if (typeVisits == null) {
      emit(const TypeVisitErro('Falha ao carregar tipos de visita da API.'));
      return;
    }
    if (typeVisits.isNotEmpty) {
      final bool saved = await _persistTypeVisitsLocally(typeVisits);
      if (!saved) {
        emit(const TypeVisitErro('Falha ao gravar tipos de visita localmente.'));
        return;
      }
    }

    emit(TypeVisitListLoaded(typeVisits));
  }

  Future<bool> _persistTypeVisitsLocally(List<TypeVisitResponseModel> typeVisits) async {
    for (final TypeVisitResponseModel typeVisit in typeVisits) {
      final existsResult = await _typeVisitLocalRepository.obterPorId(typeVisit.id, typeVisit.orgOwner);
      final saveResult = await existsResult.fold(
        (_) async => _typeVisitLocalRepository.alterar(typeVisit),
        (_) async => _typeVisitLocalRepository.gravar(typeVisit),
      );

      final bool success = saveResult.fold((value) => value, (_) => false);
      if (!success) return false;
    }

    return true;
  }

  Future<void> carregarTypeVisits() async {
    emit(const TypeVisitLoading());

    final result = await _typeVisitLocalRepository.typeVisits();
    result.fold(
      (typeVisits) => emit(TypeVisitListLoaded(typeVisits)),
      (_) => emit(const TypeVisitErro('Falha ao carregar tipos de visita.')),
    );
  }

  Future<void> obterPorId(int id, String orgOwner) async {
    emit(const TypeVisitLoading());

    final result = await _typeVisitLocalRepository.obterPorId(id, orgOwner);
    result.fold(
      (typeVisit) => emit(TypeVisitLoaded(typeVisit)),
      (_) => emit(const TypeVisitErro('Tipo de visita não encontrado.')),
    );
  }

  Future<void> gravar(TypeVisitResponseModel typeVisit) async {
    emit(const TypeVisitLoading());

    final result = await _typeVisitLocalRepository.gravar(typeVisit);
    result.fold((success) {
      if (success) {
        emit(const TypeVisitGravadoSucesso());
      } else {
        emit(const TypeVisitErro('Falha ao gravar tipo de visita.'));
      }
    }, (_) => emit(const TypeVisitErro('Falha ao gravar tipo de visita.')));
  }

  Future<void> alterar(TypeVisitResponseModel typeVisit) async {
    emit(const TypeVisitLoading());

    final result = await _typeVisitLocalRepository.alterar(typeVisit);
    result.fold((success) {
      if (success) {
        emit(const TypeVisitAlteradoSucesso());
      } else {
        emit(const TypeVisitErro('Falha ao alterar tipo de visita.'));
      }
    }, (_) => emit(const TypeVisitErro('Falha ao alterar tipo de visita.')));
  }
}
