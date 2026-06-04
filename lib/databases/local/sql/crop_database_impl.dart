import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/crop_local_repository.dart';
import 'package:farmtracker/databases/local/tables/crop_table.dart';
import 'package:farmtracker/domains/models/crop_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class CropDatabaseImpl implements CropLocalRepository {
  final Future<Database> Function()? _databaseProvider;

  CropDatabaseImpl({Future<Database> Function()? databaseProvider}) : _databaseProvider = databaseProvider;

  Future<Database> _getDatabase() async {
    final provider = _databaseProvider;
    if (provider != null) {
      return provider();
    }
    return FarmTrackerDatabase.instance.dataBase;
  }

  @override
  AsyncResult<List<CropModel>> obterPorName(String name) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(cropTable, where: 'name like ?', whereArgs: ['$name%']);
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<CropModel> obterPorId(String id, String orgOwner) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(
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
  AsyncResult<bool> gravar(CropModel crop) async {
    try {
      final Database db = await _getDatabase();
      await db.insert(cropTable, crop.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(CropModel crop) async {
    try {
      final Database db = await _getDatabase();
      final result = await db.update(
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

  @override
  AsyncResult<List<CropModel>> crops() async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(cropTable, orderBy: 'name');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  List<CropModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => CropModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
