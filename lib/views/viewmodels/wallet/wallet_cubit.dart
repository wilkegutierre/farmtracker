import 'package:farmtracker/databases/local/repositories/wallet_local_repository.dart';
import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:farmtracker/views/viewmodels/wallet/wallet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletLocalRepository _walletLocalRepository;

  WalletCubit(this._walletLocalRepository) : super(const WalletInitial());

  Future<void> carregarWallets() async {
    emit(const WalletLoading());

    final result = await _walletLocalRepository.wallets();
    result.fold(
      (wallets) => emit(WalletListLoaded(wallets)),
      (_) => emit(const WalletErro('Falha ao carregar wallets.')),
    );
  }

  Future<void> obterPorOwner(String owner) async {
    emit(const WalletLoading());

    final result = await _walletLocalRepository.obterPorOwner(owner);
    result.fold(
      (wallets) => emit(WalletListLoaded(wallets)),
      (_) => emit(const WalletErro('Falha ao buscar wallets por owner.')),
    );
  }

  Future<void> obterPorId(String id) async {
    emit(const WalletLoading());

    final result = await _walletLocalRepository.obterPorId(id);
    result.fold(
      (wallet) => emit(WalletLoaded(wallet)),
      (_) => emit(const WalletErro('Wallet não encontrada.')),
    );
  }

  Future<void> gravar(WalletModel wallet) async {
    emit(const WalletLoading());

    final result = await _walletLocalRepository.gravar(wallet);
    result.fold(
      (success) {
        if (success) {
          emit(const WalletGravadoSucesso());
        } else {
          emit(const WalletErro('Falha ao gravar wallet.'));
        }
      },
      (_) => emit(const WalletErro('Falha ao gravar wallet.')),
    );
  }

  Future<void> alterar(WalletModel wallet) async {
    emit(const WalletLoading());

    final result = await _walletLocalRepository.alterar(wallet);
    result.fold(
      (success) {
        if (success) {
          emit(const WalletAlteradoSucesso());
        } else {
          emit(const WalletErro('Falha ao alterar wallet.'));
        }
      },
      (_) => emit(const WalletErro('Falha ao alterar wallet.')),
    );
  }
}
