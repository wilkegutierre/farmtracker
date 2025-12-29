import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/lote_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/tables/lote_cultura_table.dart';
import 'package:farmtracker/domains/models/lote_cultura_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class LoteCulturaDatabaseImpl implements LoteCulturaLocalRepository {
  late Database db;

  @override
  AsyncResult<bool> gravar(LoteCulturaModel loteCulturaModel) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      await db.insert(loteCulturaTable, loteCulturaModel.toJson());
      return const Success(true);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> atualizar(LoteCulturaModel loteCulturaModel) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        loteCulturaTable,
        loteCulturaModel.toJson(),
        where: 'loteId = ? and culturaId = ?',
        whereArgs: [loteCulturaModel.lote, loteCulturaModel.cultura],
      );
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<List<LoteCulturaModel>> obterPorLote(String loteId) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(loteCulturaTable, where: 'loteId = ?', whereArgs: [loteId]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<LoteCulturaModel> motivosResult = [];
        for (var item in result as List) {
          motivosResult.add(LoteCulturaModel.fromJson(item));
        }
        return Success(motivosResult);
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<LoteCulturaModel> obterPorLoteCultura(String loteId, String culturaId) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(
        loteCulturaTable,
        where: 'loteId = ? and culturaId = ?',
        whereArgs: [loteId, culturaId],
      );
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        ).first;
        return Success(LoteCulturaModel.fromJson(result));
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<LoteCulturaModel>> obterTodos() async {
    try {
      final data = await db.query(loteCulturaTable);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<LoteCulturaModel> motivosResult = [];
        for (var item in result as List) {
          motivosResult.add(LoteCulturaModel.fromJson(item));
        }
        return Success(motivosResult);
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }
}
