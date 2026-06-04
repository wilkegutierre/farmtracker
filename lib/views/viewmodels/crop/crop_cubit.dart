import 'package:farmtracker/databases/local/repositories/crop_local_repository.dart';
import 'package:farmtracker/domains/models/crop_model.dart';
import 'package:farmtracker/views/viewmodels/crop/crop_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropCubit extends Cubit<CropState> {
  final CropLocalRepository _cropLocalRepository;

  CropCubit(this._cropLocalRepository) : super(const CropInitial());

  Future<void> carregarCrops() async {
    emit(const CropLoading());

    final result = await _cropLocalRepository.crops();
    result.fold(
      (crops) => emit(CropListLoaded(crops)),
      (_) => emit(const CropErro('Falha ao carregar crops.')),
    );
  }

  Future<void> obterPorName(String name) async {
    emit(const CropLoading());

    final result = await _cropLocalRepository.obterPorName(name);
    result.fold(
      (crops) => emit(CropListLoaded(crops)),
      (_) => emit(const CropErro('Falha ao buscar crop por nome.')),
    );
  }

  Future<void> obterPorId(String id, String orgOwner) async {
    emit(const CropLoading());

    final result = await _cropLocalRepository.obterPorId(id, orgOwner);
    result.fold(
      (crop) => emit(CropLoaded(crop)),
      (_) => emit(const CropErro('Crop não encontrado.')),
    );
  }

  Future<void> gravar(CropModel crop) async {
    emit(const CropLoading());

    final result = await _cropLocalRepository.gravar(crop);
    result.fold(
      (success) {
        if (success) {
          emit(const CropGravadoSucesso());
        } else {
          emit(const CropErro('Falha ao gravar crop.'));
        }
      },
      (_) => emit(const CropErro('Falha ao gravar crop.')),
    );
  }

  Future<void> alterar(CropModel crop) async {
    emit(const CropLoading());

    final result = await _cropLocalRepository.alterar(crop);
    result.fold(
      (success) {
        if (success) {
          emit(const CropAlteradoSucesso());
        } else {
          emit(const CropErro('Falha ao alterar crop.'));
        }
      },
      (_) => emit(const CropErro('Falha ao alterar crop.')),
    );
  }
}
