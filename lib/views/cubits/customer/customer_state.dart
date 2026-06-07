import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

final class CustomerInitial extends CustomerState {
  const CustomerInitial();
}

final class CustomerLoading extends CustomerState {
  const CustomerLoading();
}

final class CustomerListLoaded extends CustomerState {
  final List<CustomerResponseModel> customers;

  const CustomerListLoaded(this.customers);

  @override
  List<Object?> get props => [customers];
}

final class CustomerLoaded extends CustomerState {
  final CustomerResponseModel customer;

  const CustomerLoaded(this.customer);

  @override
  List<Object?> get props => [customer];
}

final class CustomerGravadoSucesso extends CustomerState {
  const CustomerGravadoSucesso();
}

final class CustomerAlteradoSucesso extends CustomerState {
  const CustomerAlteradoSucesso();
}

final class CustomerErro extends CustomerState {
  final String mensagem;

  const CustomerErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
