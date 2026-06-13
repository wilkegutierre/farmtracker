import 'package:farmtracker/databases/local/repositories/pest_local_repository.dart';
import 'package:farmtracker/databases/models/response/pest_response_model.dart';
import 'package:farmtracker/domains/repositories/pest/pest_repository.dart';
import 'package:farmtracker/views/cubits/pest/pest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PestCubit extends Cubit<PestState> {
  final PestRepository _pestRepository;
  final PestLocalRepository _pestLocalRepository;

  PestCubit(this._pestRepository, this._pestLocalRepository) : super(const PestInitial());

  Future<void> syncPests(String orgOwner) async {
    emit(const PestLoading());

    final result = await _pestRepository.getByOrgOwner(orgOwner);
    final List<PestResponseModel>? pests = result.fold((success) => success, (_) => null);

    if (pests == null) {
      emit(const PestErro('Falha ao carregar pragas da API.'));
      return;
    }

    if (pests.isNotEmpty) {
      final bool saved = await _persistPestsLocally(pests);
      if (!saved) {
        emit(const PestErro('Falha ao gravar pragas localmente.'));
        return;
      }
    }

    emit(PestListLoaded(pests));
  }

  Future<bool> _persistPestsLocally(List<PestResponseModel> pests) async {
    for (final PestResponseModel pest in pests) {
      final existsResult = await _pestLocalRepository.obterPorId(pest.id, pest.orgOwner);
      final saveResult = await existsResult.fold(
        (_) async => _pestLocalRepository.alterar(pest),
        (_) async => _pestLocalRepository.gravar(pest),
      );

      final bool success = saveResult.fold((value) => value, (_) => false);
      if (!success) return false;
    }

    return true;
  }

  Future<void> carregarPests() async {
    emit(const PestLoading());

    final result = await _pestLocalRepository.pests();
    result.fold(
      (pests) => emit(PestListLoaded(pests)),
      (_) => emit(const PestErro('Falha ao carregar pragas.')),
    );
  }

  Future<void> obterPorId(String id, String orgOwner) async {
    emit(const PestLoading());

    final result = await _pestLocalRepository.obterPorId(id, orgOwner);
    result.fold(
      (pest) => emit(PestLoaded(pest)),
      (_) => emit(const PestErro('Praga não encontrada.')),
    );
  }

  Future<void> gravar(PestResponseModel pest) async {
    emit(const PestLoading());

    final result = await _pestLocalRepository.gravar(pest);
    result.fold((success) {
      if (success) {
        emit(const PestGravadoSucesso());
      } else {
        emit(const PestErro('Falha ao gravar praga.'));
      }
    }, (_) => emit(const PestErro('Falha ao gravar praga.')));
  }

  Future<void> alterar(PestResponseModel pest) async {
    emit(const PestLoading());

    final result = await _pestLocalRepository.alterar(pest);
    result.fold((success) {
      if (success) {
        emit(const PestAlteradoSucesso());
      } else {
        emit(const PestErro('Falha ao alterar praga.'));
      }
    }, (_) => emit(const PestErro('Falha ao alterar praga.')));
  }
}
