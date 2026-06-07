import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/databases/services/customer/customer_service.dart';
import 'package:farmtracker/domains/repositories/customer/customer_repository.dart';
import 'package:result_dart/result_dart.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerService service;

  CustomerRepositoryImpl({required this.service});

  @override
  AsyncResult<List<CustomerResponseModel>> getCustomersByWalletId(String walletId) async {
    try {
      return await service.getCustomersByWalletId(walletId).fold(
        (success) => Success(success),
        (failure) => Failure(failure),
      );
    } catch (_) {
      return Failure(InternalServerError());
    }
  }
}
