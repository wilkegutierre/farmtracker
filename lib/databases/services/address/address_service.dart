import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AddressService {
  AsyncResult<List<AddressResponseModel>> getByOwner(String ownerId);
}
