import 'package:farmtracker/databases/models/response/pest_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class PestLocalRepository {
  AsyncResult<bool> gravar(PestResponseModel pest);
  AsyncResult<bool> alterar(PestResponseModel pest);
  AsyncResult<List<PestResponseModel>> pests();
  AsyncResult<PestResponseModel> obterPorId(String id, String orgOwner);
}
