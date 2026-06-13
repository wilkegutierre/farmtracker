import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/pest_local_repository.dart';
import 'package:farmtracker/databases/local/tables/pest_table.dart';
import 'package:farmtracker/databases/models/response/pest_response_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class PestDatabaseImpl implements PestLocalRepository {
  late Database db;

  @override
  AsyncResult<List<PestResponseModel>> pests() async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(pestTable, orderBy: 'name');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<PestResponseModel> obterPorId(String id, String orgOwner) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(
        pestTable,
        where: 'id = ? AND orgOwner = ?',
        whereArgs: [id, orgOwner],
      );
      if (data.isNotEmpty) {
        return Success(PestResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(PestResponseModel pest) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      await db.insert(pestTable, pest.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(PestResponseModel pest) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        pestTable,
        pest.toJson(),
        where: 'id = ? AND orgOwner = ?',
        whereArgs: [pest.id, pest.orgOwner],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<PestResponseModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => PestResponseModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
