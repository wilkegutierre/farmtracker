import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/pest_response_model.dart';
import 'package:farmtracker/databases/services/pest/pest_service.dart';
import 'package:farmtracker/domains/repositories/pest/pest_repository.dart';
import 'package:result_dart/result_dart.dart';

class PestRepositoryImpl implements PestRepository {
  final PestService service;

  PestRepositoryImpl({required this.service});

  @override
  AsyncResult<List<PestResponseModel>> getByOrgOwner(String orgOwner) async {
    try {
      return await service.getByOrgOwner(orgOwner).fold(
        (success) => Success(success),
        (failure) => Failure(failure),
      );
    } catch (_) {
      return Failure(InternalServerError());
    }
  }

  @override
  AsyncResult<PestResponseModel> getById(String id) async {
    try {
      return await service.getById(id).fold(
        (success) => Success(success),
        (failure) => Failure(failure),
      );
    } catch (_) {
      return Failure(InternalServerError());
    }
  }
}
