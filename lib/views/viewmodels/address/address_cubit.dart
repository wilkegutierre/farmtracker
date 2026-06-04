import 'package:farmtracker/databases/local/repositories/address_local_repository.dart';
import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:farmtracker/views/viewmodels/address/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressLocalRepository _addressLocalRepository;

  AddressCubit(this._addressLocalRepository) : super(const AddressInitial());

  Future<void> carregarAddresses() async {
    emit(const AddressLoading());

    final result = await _addressLocalRepository.addresses();
    result.fold(
      (addresses) => emit(AddressListLoaded(addresses)),
      (_) => emit(const AddressErro('Falha ao carregar addresses.')),
    );
  }

  Future<void> obterPorOwner(String owner) async {
    emit(const AddressLoading());

    final result = await _addressLocalRepository.obterPorOwner(owner);
    result.fold(
      (addresses) => emit(AddressListLoaded(addresses)),
      (_) => emit(const AddressErro('Falha ao buscar addresses por owner.')),
    );
  }

  Future<void> obterPorOrgOwner(String orgOwner) async {
    emit(const AddressLoading());

    final result = await _addressLocalRepository.obterPorOrgOwner(orgOwner);
    result.fold(
      (addresses) => emit(AddressListLoaded(addresses)),
      (_) => emit(const AddressErro('Falha ao buscar addresses por org_owner.')),
    );
  }

  Future<void> obterPorId(String id) async {
    emit(const AddressLoading());

    final result = await _addressLocalRepository.obterPorId(id);
    result.fold(
      (address) => emit(AddressLoaded(address)),
      (_) => emit(const AddressErro('Address não encontrado.')),
    );
  }

  Future<void> gravar(AddressResponseModel address) async {
    emit(const AddressLoading());

    final result = await _addressLocalRepository.gravar(address);
    result.fold(
      (success) {
        if (success) {
          emit(const AddressGravadoSucesso());
        } else {
          emit(const AddressErro('Falha ao gravar address.'));
        }
      },
      (_) => emit(const AddressErro('Falha ao gravar address.')),
    );
  }

  Future<void> alterar(AddressResponseModel address) async {
    emit(const AddressLoading());

    final result = await _addressLocalRepository.alterar(address);
    result.fold(
      (success) {
        if (success) {
          emit(const AddressAlteradoSucesso());
        } else {
          emit(const AddressErro('Falha ao alterar address.'));
        }
      },
      (_) => emit(const AddressErro('Falha ao alterar address.')),
    );
  }
}
