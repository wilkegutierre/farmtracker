import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AddressLocalRepository {
  AsyncResult<bool> gravar(AddressResponseModel address);
  AsyncResult<bool> alterar(AddressResponseModel address);
  AsyncResult<List<AddressResponseModel>> addresses();
  AsyncResult<AddressResponseModel> obterPorId(String id);
  AsyncResult<List<AddressResponseModel>> obterPorOwner(String owner);
  AsyncResult<List<AddressResponseModel>> obterPorOrgOwner(String orgOwner);
}
