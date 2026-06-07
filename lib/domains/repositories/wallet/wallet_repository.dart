import 'package:farmtracker/databases/models/response/wallet_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class WalletRepository {
  AsyncResult<List<WalletResponseModel>> getWalletsByUserId(String userId);
}
