import 'package:farmtracker/databases/local/repositories/customer_local_repository.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:farmtracker/domains/repositories/customer/customer_repository.dart';
import 'package:farmtracker/views/cubits/customer/customer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerRepository _customerRepository;
  final CustomerLocalRepository _customerLocalRepository;

  CustomerCubit(this._customerRepository, this._customerLocalRepository) : super(const CustomerInitial());

  Future<void> syncCustomersByWallet(List<WalletModel> wallets) async {
    emit(const CustomerLoading());

    final results = wallets.map((wallet) => _customerRepository.getCustomersByWalletId(wallet.id)).toList();
    final customers = await Future.wait(results);

    final List<CustomerResponseModel> allCustomers = [];
    for (final customer in customers) {
      final bool failed = customer.fold((item) {
        allCustomers.addAll(item);
        return false;
      }, (_) => true);

      if (failed) {
        emit(const CustomerErro('Falha ao carregar customers da carteira.'));
        return;
      }
    }

    if (allCustomers.isNotEmpty) {
      final bool saved = await _persistCustomersLocally(allCustomers);
      if (!saved) {
        emit(const CustomerErro('Falha ao gravar customers localmente.'));
        return;
      }
    }

    emit(CustomerListLoaded(allCustomers));
  }

  Future<bool> _persistCustomersLocally(List<CustomerResponseModel> customers) async {
    for (final CustomerResponseModel customer in customers) {
      final existsResult = await _customerLocalRepository.obterPorId(customer.id);
      final saveResult = await existsResult.fold(
        (_) async => _customerLocalRepository.alterar(customer),
        (_) async => _customerLocalRepository.gravar(customer),
      );

      final bool success = saveResult.fold((value) => value, (_) => false);
      if (!success) return false;
    }

    return true;
  }

  Future<void> carregarCustomers() async {
    emit(const CustomerLoading());

    final result = await _customerLocalRepository.customers();
    result.fold(
      (customers) => emit(CustomerListLoaded(customers)),
      (_) => emit(const CustomerErro('Falha ao carregar customers.')),
    );
  }

  Future<void> obterPorOrgOwner(String orgOwner) async {
    emit(const CustomerLoading());

    final result = await _customerLocalRepository.obterPorOrgOwner(orgOwner);
    result.fold(
      (customers) => emit(CustomerListLoaded(customers)),
      (_) => emit(const CustomerErro('Falha ao buscar customers por org_owner.')),
    );
  }

  Future<void> obterPorId(String id) async {
    emit(const CustomerLoading());

    final result = await _customerLocalRepository.obterPorId(id);
    result.fold(
      (customer) => emit(CustomerLoaded(customer)),
      (_) => emit(const CustomerErro('Customer não encontrado.')),
    );
  }

  Future<void> gravar(CustomerResponseModel customer) async {
    emit(const CustomerLoading());

    final result = await _customerLocalRepository.gravar(customer);
    result.fold((success) {
      if (success) {
        emit(const CustomerGravadoSucesso());
      } else {
        emit(const CustomerErro('Falha ao gravar customer.'));
      }
    }, (_) => emit(const CustomerErro('Falha ao gravar customer.')));
  }

  Future<void> alterar(CustomerResponseModel customer) async {
    emit(const CustomerLoading());

    final result = await _customerLocalRepository.alterar(customer);
    result.fold((success) {
      if (success) {
        emit(const CustomerAlteradoSucesso());
      } else {
        emit(const CustomerErro('Falha ao alterar customer.'));
      }
    }, (_) => emit(const CustomerErro('Falha ao alterar customer.')));
  }
}
