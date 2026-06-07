import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class BaseEntityRepository {
  AsyncResult<List<BaseEntityResponseModel>> getByOwnerId(String ownerId);
}
