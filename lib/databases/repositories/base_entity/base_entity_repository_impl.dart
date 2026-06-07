import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:farmtracker/databases/services/base_entity/base_entity_service.dart';
import 'package:farmtracker/domains/repositories/base_entity/base_entity_repository.dart';
import 'package:result_dart/result_dart.dart';

class BaseEntityRepositoryImpl implements BaseEntityRepository {
  final BaseEntityService service;

  BaseEntityRepositoryImpl({required this.service});

  @override
  AsyncResult<List<BaseEntityResponseModel>> getByOwnerId(String ownerId) async {
    try {
      return await service.getByOwnerId(ownerId).fold(
        (success) => Success(success),
        (failure) => Failure(failure),
      );
    } catch (_) {
      return Failure(InternalServerError());
    }
  }
}
