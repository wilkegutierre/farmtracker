import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/wallet_model.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

final class WalletInitial extends WalletState {
  const WalletInitial();
}

final class WalletLoading extends WalletState {
  const WalletLoading();
}

final class WalletListLoaded extends WalletState {
  final List<WalletModel> wallets;

  const WalletListLoaded(this.wallets);

  @override
  List<Object?> get props => [wallets];
}

final class WalletLoaded extends WalletState {
  final WalletModel wallet;

  const WalletLoaded(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

final class WalletGravadoSucesso extends WalletState {
  const WalletGravadoSucesso();
}

final class WalletAlteradoSucesso extends WalletState {
  const WalletAlteradoSucesso();
}

final class WalletErro extends WalletState {
  final String mensagem;

  const WalletErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
