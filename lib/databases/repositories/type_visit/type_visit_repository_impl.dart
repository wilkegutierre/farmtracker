import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:farmtracker/databases/services/type_visit/type_visit_service.dart';
import 'package:farmtracker/domains/repositories/type_visit/type_visit_repository.dart';
import 'package:result_dart/result_dart.dart';

class TypeVisitRepositoryImpl implements TypeVisitRepository {
  final TypeVisitService service;

  TypeVisitRepositoryImpl({required this.service});

  @override
  AsyncResult<List<TypeVisitResponseModel>> getByOrgOwner(String orgOwner) async {
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
  AsyncResult<TypeVisitResponseModel> getById(int id) async {
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
