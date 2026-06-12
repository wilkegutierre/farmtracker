import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/type_visit_local_repository.dart';
import 'package:farmtracker/databases/local/tables/type_visit_table.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class TypeVisitDatabaseImpl implements TypeVisitLocalRepository {
  late Database db;

  @override
  AsyncResult<List<TypeVisitResponseModel>> typeVisits() async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(typeVisitTable, orderBy: 'description');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<TypeVisitResponseModel> obterPorId(int id, String orgOwner) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(
        typeVisitTable,
        where: 'id = ? AND orgOwner = ?',
        whereArgs: [id, orgOwner],
      );
      if (data.isNotEmpty) {
        return Success(TypeVisitResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(TypeVisitResponseModel typeVisit) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      await db.insert(typeVisitTable, typeVisit.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(TypeVisitResponseModel typeVisit) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        typeVisitTable,
        typeVisit.toJson(),
        where: 'id = ? AND orgOwner = ?',
        whereArgs: [typeVisit.id, typeVisit.orgOwner],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<TypeVisitResponseModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => TypeVisitResponseModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
