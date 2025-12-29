import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/models/response/cultura_response_model.dart';
import 'package:farmtracker/databases/services/cultura/cultura_service.dart';
import 'package:farmtracker/domains/repositories/cultura/cultura_repository.dart';
import 'package:result_dart/result_dart.dart';

class CulturaRepositoryImpl implements CulturaRepository {
  final CulturaService service;

  CulturaRepositoryImpl(this.service);

  @override
  AsyncResult<List<CulturaResponseModel>> baixarCulturas(String cliente) async {
    try {
      final result = await service.baixarCulturas(cliente);
      return result.fold((success) => Success(success), (failure) => Failure(failure));
    } catch (e) {
      return Failure(InternetConnectionError(message: e.toString()));
    }
  }
}
