import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:farmtracker/databases/services/address/address_service.dart';
import 'package:farmtracker/domains/repositories/address/address_repository.dart';
import 'package:result_dart/result_dart.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressService service;

  AddressRepositoryImpl({required this.service});

  @override
  AsyncResult<List<AddressResponseModel>> getByOwner(String ownerId) async {
    try {
      return await service.getByOwner(ownerId).fold(
        (success) => Success(success),
        (failure) => Failure(failure),
      );
    } catch (_) {
      return Failure(InternalServerError());
    }
  }
}
