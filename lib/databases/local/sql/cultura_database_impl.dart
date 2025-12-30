import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/cultura_local_repository.dart';
import 'package:farmtracker/databases/local/tables/cultura_table.dart';
import 'package:farmtracker/domains/models/cultura_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class CulturaDatabaseImpl implements CulturaLocalRepository {
  late Database db;

  @override
  AsyncResult<List<CulturaModel>> obterPorNome(String nome) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'nome';
      final data = await db.query(culturaTable, where: '$whereField like ?', whereArgs: ['$nome%']);
      List<CulturaModel> culturasResult = [];
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        for (var item in result as List) {
          culturasResult.add(CulturaModel.fromJson(item));
        }
        return Success(culturasResult);
      }
      return Success(culturasResult);
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<CulturaModel> obterPorUuid(String uuid) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'uuid';
      final data = await db.query(culturaTable, where: '$whereField = ?', whereArgs: [uuid]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        ).first;
        return Success(CulturaModel.fromJson(result));
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(CulturaModel cultura) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      await db.insert(culturaTable, cultura.toJson());
      return const Success(true);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(CulturaModel cultura) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(culturaTable, cultura.toJson(), where: 'uuid = ?', whereArgs: [cultura.uuid]);
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<List<CulturaModel>> culturas() async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(culturaTable, orderBy: 'nome');
      List<CulturaModel> culturasResult = [];
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        for (var item in result as List) {
          culturasResult.add(CulturaModel.fromJson(item));
        }
        return Success(culturasResult);
      }
      return Success(culturasResult);
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }
}
