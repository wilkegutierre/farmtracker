import 'package:farmtracker/databases/models/response/organization_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class OrganizationLocalRepository {
  AsyncResult<bool> gravar(OrganizationResponseModel organization);
  AsyncResult<bool> alterar(OrganizationResponseModel organization);
  AsyncResult<List<OrganizationResponseModel>> organizations();
  AsyncResult<OrganizationResponseModel> obterPorId(String id);
  AsyncResult<List<OrganizationResponseModel>> obterPorAddressId(String addressId);
}
