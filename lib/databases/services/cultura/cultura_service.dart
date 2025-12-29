import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/models/response/cultura_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class CulturaService {
  AsyncResult<List<CulturaResponseModel>> baixarCulturas(String cliente);
}
