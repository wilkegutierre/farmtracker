import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/base_entity_local_repository.dart';
import 'package:farmtracker/databases/local/tables/base_entity_table.dart';
import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class BaseEntityDatabaseImpl implements BaseEntityLocalRepository {
  final Future<Database> Function()? _databaseProvider;

  BaseEntityDatabaseImpl({Future<Database> Function()? databaseProvider}) : _databaseProvider = databaseProvider;

  Future<Database> _getDatabase() async {
    final provider = _databaseProvider;
    if (provider != null) {
      return provider();
    }
    return FarmTrackerDatabase.instance.dataBase;
  }

  @override
  AsyncResult<List<BaseEntityResponseModel>> baseEntities() async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(baseEntityTable, orderBy: 'name');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<BaseEntityResponseModel> obterPorId(String id) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(baseEntityTable, where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return Success(BaseEntityResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<BaseEntityResponseModel>> obterPorType(String type) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(baseEntityTable, where: 'type = ?', whereArgs: [type], orderBy: 'name');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<BaseEntityResponseModel> obterPorDocNumber(String docNumber) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(baseEntityTable, where: 'doc_number = ?', whereArgs: [docNumber]);
      if (data.isNotEmpty) {
        return Success(BaseEntityResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(BaseEntityResponseModel baseEntity) async {
    try {
      final Database db = await _getDatabase();
      await db.insert(baseEntityTable, baseEntity.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(BaseEntityResponseModel baseEntity) async {
    try {
      final Database db = await _getDatabase();
      final result = await db.update(
        baseEntityTable,
        baseEntity.toJson(),
        where: 'id = ?',
        whereArgs: [baseEntity.id],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<BaseEntityResponseModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => BaseEntityResponseModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
