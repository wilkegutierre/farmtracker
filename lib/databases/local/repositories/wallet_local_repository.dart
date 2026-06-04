import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class WalletLocalRepository {
  AsyncResult<bool> gravar(WalletModel wallet);
  AsyncResult<bool> alterar(WalletModel wallet);
  AsyncResult<List<WalletModel>> wallets();
  AsyncResult<WalletModel> obterPorId(String id);
  AsyncResult<List<WalletModel>> obterPorOwner(String owner);
}
