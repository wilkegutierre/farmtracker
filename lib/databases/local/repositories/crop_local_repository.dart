import 'package:farmtracker/domains/models/crop_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class CropLocalRepository {
  AsyncResult<bool> gravar(CropModel crop);
  AsyncResult<bool> alterar(CropModel crop);
  AsyncResult<List<CropModel>> crops();
  AsyncResult<List<CropModel>> obterPorName(String name);
  AsyncResult<CropModel> obterPorId(String id, String orgOwner);
}
