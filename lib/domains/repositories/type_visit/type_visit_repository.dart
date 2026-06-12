import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class TypeVisitRepository {
  AsyncResult<List<TypeVisitResponseModel>> getByOrgOwner(String orgOwner);
  AsyncResult<TypeVisitResponseModel> getById(int id);
}
