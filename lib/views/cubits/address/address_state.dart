import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/address_response_model.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

final class AddressInitial extends AddressState {
  const AddressInitial();
}

final class AddressLoading extends AddressState {
  const AddressLoading();
}

final class AddressListLoaded extends AddressState {
  final List<AddressResponseModel> addresses;

  const AddressListLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

final class AddressLoaded extends AddressState {
  final AddressResponseModel address;

  const AddressLoaded(this.address);

  @override
  List<Object?> get props => [address];
}

final class AddressGravadoSucesso extends AddressState {
  const AddressGravadoSucesso();
}

final class AddressAlteradoSucesso extends AddressState {
  const AddressAlteradoSucesso();
}

final class AddressErro extends AddressState {
  final String mensagem;

  const AddressErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
