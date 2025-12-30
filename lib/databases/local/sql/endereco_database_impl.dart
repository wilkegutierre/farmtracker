import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/endereco_local_repository.dart';
import 'package:farmtracker/databases/local/tables/endereco_table.dart';
import 'package:farmtracker/domains/models/endereco_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class EnderecoDatabaseImpl implements EnderecoLocalRepository {
  late Database db;

  @override
  AsyncResult<List<EnderecoModel>> obterPorCliente(String cliente) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'pessoa';
      final data = await db.query(enderecoTable, where: '$whereField = ?', whereArgs: [cliente]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<EnderecoModel> motivosResult = [];
        for (var item in result as List) {
          motivosResult.add(EnderecoModel.fromJson(item));
        }
        return Success(motivosResult);
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<EnderecoModel>> obterPorLogradouro(String logradouro) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'logradouro';
      final data = await db.query(enderecoTable, where: '$whereField = ?', whereArgs: [logradouro]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<EnderecoModel> motivosResult = [];
        for (var item in result as List) {
          motivosResult.add(EnderecoModel.fromJson(item));
        }
        return Success(motivosResult);
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<EnderecoModel> obterPorUuid(String uuid) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'uuid';
      final data = await db.query(enderecoTable, where: '$whereField = ?', whereArgs: [uuid]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        ).first;
        return Success(EnderecoModel.fromJson(result));
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(EnderecoModel endereco) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final response = await db.insert(enderecoTable, endereco.toJson());
      return Success(response == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> atualizar(EnderecoModel endereco) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(enderecoTable, endereco.toJson(), where: 'uuid = ?', whereArgs: [endereco.uuid]);
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }
}
