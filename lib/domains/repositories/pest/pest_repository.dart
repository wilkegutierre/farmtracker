import 'package:farmtracker/databases/models/response/pest_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class PestRepository {
  AsyncResult<List<PestResponseModel>> getByOrgOwner(String orgOwner);
  AsyncResult<PestResponseModel> getById(String id);
}
