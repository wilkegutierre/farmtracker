import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AddressRepository {
  AsyncResult<List<AddressResponseModel>> getByOwner(String ownerId);
}
