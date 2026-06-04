import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class CustomerLocalRepository {
  AsyncResult<bool> gravar(CustomerResponseModel customer);
  AsyncResult<bool> alterar(CustomerResponseModel customer);
  AsyncResult<List<CustomerResponseModel>> customers();
  AsyncResult<CustomerResponseModel> obterPorId(String id);
  AsyncResult<List<CustomerResponseModel>> obterPorOrgOwner(String orgOwner);
}
