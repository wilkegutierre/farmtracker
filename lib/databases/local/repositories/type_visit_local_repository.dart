import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class TypeVisitLocalRepository {
  AsyncResult<bool> gravar(TypeVisitResponseModel typeVisit);
  AsyncResult<bool> alterar(TypeVisitResponseModel typeVisit);
  AsyncResult<List<TypeVisitResponseModel>> typeVisits();
  AsyncResult<TypeVisitResponseModel> obterPorId(int id, String orgOwner);
}
