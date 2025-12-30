import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/projeto_local_repository.dart';
import 'package:farmtracker/databases/local/tables/projeto_table.dart';
import 'package:farmtracker/domains/models/projeto_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class ProjetoDatabaseImpl implements ProjetoLocalRepository {
  late Database db;

  @override
  AsyncResult<bool> gravar(ProjetoModel projeto) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      await db.insert(projetoTable, projeto.toJson());
      return const Success(true);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(ProjetoModel projeto) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        projetoTable,
        projeto.toJson(),
        where: 'uuid = ? and clienteId = ?',
        whereArgs: [projeto.uuid, projeto.clienteId],
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
      final result = await db.delete(projetoTable, where: 'uuid = ?', whereArgs: [uuid]);
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<List<ProjetoModel>> obterPorCliente(String cliente) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(projetoTable, where: 'clienteId = ?', whereArgs: [cliente]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<ProjetoModel> projetosResult = [];
        for (var item in result as List) {
          projetosResult.add(ProjetoModel.fromJson(item));
        }
        return Success(projetosResult);
      }
      return Failure(NotFoundDataBaseError());
    } catch (e) {
      return Failure(NotFoundDataBaseError());
    }
  }

  @override
  AsyncResult<ProjetoModel> obterPorUuid(String uuid) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(projetoTable, where: 'uuid = ?', whereArgs: [uuid]);
      if (data.isNotEmpty) {
        final result = Map<String, dynamic>.from(data.first);
        return Success(ProjetoModel.fromJson(result));
      }
      return Failure(NotFoundDataBaseError());
    } catch (e) {
      return Failure(NotFoundDataBaseError());
    }
  }

  @override
  AsyncResult<List<ProjetoModel>> obterTodos() async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(projetoTable);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<ProjetoModel> projetosResult = [];
        for (var item in result as List) {
          projetosResult.add(ProjetoModel.fromJson(item));
        }
        return Success(projetosResult);
      }
      return Failure(NotFoundDataBaseError());
    } catch (e) {
      return Failure(NotFoundDataBaseError());
    }
  }
}
