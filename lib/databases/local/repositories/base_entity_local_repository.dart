import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class BaseEntityLocalRepository {
  AsyncResult<bool> gravar(BaseEntityResponseModel baseEntity);
  AsyncResult<bool> alterar(BaseEntityResponseModel baseEntity);
  AsyncResult<List<BaseEntityResponseModel>> baseEntities();
  AsyncResult<BaseEntityResponseModel> obterPorId(String id);
  AsyncResult<List<BaseEntityResponseModel>> obterPorType(String type);
  AsyncResult<BaseEntityResponseModel> obterPorDocNumber(String docNumber);
}
