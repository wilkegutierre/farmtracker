import 'package:farmtracker/databases/local/repositories/customer_local_repository.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/views/viewmodels/customer/customer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerLocalRepository _customerLocalRepository;

  CustomerCubit(this._customerLocalRepository) : super(const CustomerInitial());

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
