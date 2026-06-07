import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/crop_local_repository.dart';
import 'package:farmtracker/databases/local/tables/crop_table.dart';
import 'package:farmtracker/domains/models/crop_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

/// Repositório in-memory usado apenas nos testes, sem depender de [FarmTrackerDatabase].
class InMemoryCropLocalRepository implements CropLocalRepository {
  InMemoryCropLocalRepository(this._database);

  final Database _database;

  @override
  AsyncResult<List<CropModel>> crops() async {
    try {
      final data = await _database.query(cropTable, orderBy: 'name');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<CropModel> obterPorId(String id, String orgOwner) async {
    try {
      final data = await _database.query(
        cropTable,
        where: 'id = ? and org_owner = ?',
        whereArgs: [id, orgOwner],
      );
      if (data.isNotEmpty) {
        return Success(CropModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<CropModel>> obterPorName(String name) async {
    try {
      final data = await _database.query(cropTable, where: 'name like ?', whereArgs: ['$name%']);
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(CropModel crop) async {
    try {
      await _database.insert(cropTable, crop.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(CropModel crop) async {
    try {
      final result = await _database.update(
        cropTable,
        crop.toJson(),
        where: 'id = ? and org_owner = ?',
        whereArgs: [crop.id, crop.orgOwner],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<CropModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => CropModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
