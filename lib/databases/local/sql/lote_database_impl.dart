import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/lote_local_repository.dart';
import 'package:farmtracker/databases/local/tables/lote_table.dart';
import 'package:farmtracker/domains/models/lote_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class LoteDatabaseImpl implements LoteLocalRepository {
  late Database db;
  @override
  AsyncResult<bool> gravar(LoteModel lote) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      await db.insert(loteTable, lote.toJson());
      return const Success(true);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(LoteModel lote) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        loteTable,
        lote.toJson(),
        where: 'uuid = ? and projetoId = ?',
        whereArgs: [lote.uuid, lote.projeto],
      );
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> apagar(String uuid) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.delete(loteTable, where: 'uuid = ?', whereArgs: [uuid]);
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<List<LoteModel>> obterPorProjeto(String projeto) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(loteTable, where: 'projetoId = ?', whereArgs: [projeto]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<LoteModel> lotes = [];
        for (var item in result as List) {
          lotes.add(LoteModel.fromJson(item));
        }
        return Success(lotes);
      }
      return Failure(NotFoundDataBaseError());
    } catch (e) {
      return Failure(NotFoundDataBaseError());
    }
  }

  @override
  AsyncResult<LoteModel> obterPorUuid(String uuid) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(loteTable, where: 'uuid = ?', whereArgs: [uuid]);
      if (data.isNotEmpty) {
        if (data.isNotEmpty) {
          final result = Map<String, dynamic>.from(data.first);
          return Success(LoteModel.fromJson(result));
        }
      }
      return Failure(NotFoundDataBaseError());
    } catch (e) {
      return Failure(NotFoundDataBaseError());
    }
  }

  @override
  AsyncResult<List<LoteModel>> obterTodos() async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(loteTable);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<LoteModel> lotes = [];
        for (var item in result as List) {
          lotes.add(LoteModel.fromJson(item));
        }
        return Success(lotes);
      }
      return Failure(NotFoundDataBaseError());
    } catch (e) {
      return Failure(NotFoundDataBaseError());
    }
  }
}
