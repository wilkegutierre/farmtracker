import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class CustomerService {
  AsyncResult<List<CustomerResponseModel>> getCustomersByWalletId(String walletId);
}
