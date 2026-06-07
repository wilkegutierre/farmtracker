import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/wallet_response_model.dart';
import 'package:farmtracker/databases/services/wallet/wallet_service.dart';
import 'package:farmtracker/domains/repositories/wallet/wallet_repository.dart';
import 'package:result_dart/result_dart.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletService service;

  WalletRepositoryImpl({required this.service});

  @override
  AsyncResult<List<WalletResponseModel>> getWalletsByUserId(String userId) async {
    try {
      return await service
          .getWalletsByUserId(userId)
          .fold((success) => Success(success), (failure) => Failure(failure));
    } catch (_) {
      return Failure(InternalServerError());
    }
  }
}
