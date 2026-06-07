import 'package:farmtracker/databases/local/repositories/address_local_repository.dart';
import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/domains/repositories/address/address_repository.dart';
import 'package:farmtracker/views/cubits/address/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository _addressRepository;
  final AddressLocalRepository _addressLocalRepository;

  AddressCubit(this._addressRepository, this._addressLocalRepository) : super(const AddressInitial());

  Future<void> syncAddressesByCustomers(List<CustomerResponseModel> customers) async {
    emit(const AddressLoading());

    final results = customers.map((customer) => _addressRepository.getByOwner(customer.address!)).toList();
    final addressesResults = await Future.wait(results);

    final List<AddressResponseModel> allAddresses = [];
    for (final result in addressesResults) {
      final bool failed = result.fold((addresses) {
        allAddresses.addAll(addresses);
        return false;
      }, (_) => true);

      if (failed) {
        emit(const AddressErro('Falha ao carregar addresses por owner.'));
        return;
      }
    }

    if (allAddresses.isNotEmpty) {
      final bool saved = await _persistAddressesLocally(allAddresses);
      if (!saved) {
        emit(const AddressErro('Falha ao gravar addresses localmente.'));
        return;
      }
    }

    emit(AddressListLoaded(allAddresses));
  }

  Future<bool> _persistAddressesLocally(List<AddressResponseModel> addresses) async {
    for (final AddressResponseModel address in addresses) {
      final existsResult = await _addressLocalRepository.obterPorId(address.id);
      final saveResult = await existsResult.fold(
        (_) async => _addressLocalRepository.alterar(address),
        (_) async => _addressLocalRepository.gravar(address),
      );

      final bool success = saveResult.fold((value) => value, (_) => false);
      if (!success) return false;
    }

    return true;
  }

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
    result.fold((address) => emit(AddressLoaded(address)), (_) => emit(const AddressErro('Address não encontrado.')));
  }

  Future<void> gravar(AddressResponseModel address) async {
    emit(const AddressLoading());

    final result = await _addressLocalRepository.gravar(address);
    result.fold((success) {
      if (success) {
        emit(const AddressGravadoSucesso());
      } else {
        emit(const AddressErro('Falha ao gravar address.'));
      }
    }, (_) => emit(const AddressErro('Falha ao gravar address.')));
  }

  Future<void> alterar(AddressResponseModel address) async {
    emit(const AddressLoading());

    final result = await _addressLocalRepository.alterar(address);
    result.fold((success) {
      if (success) {
        emit(const AddressAlteradoSucesso());
      } else {
        emit(const AddressErro('Falha ao alterar address.'));
      }
    }, (_) => emit(const AddressErro('Falha ao alterar address.')));
  }
}
