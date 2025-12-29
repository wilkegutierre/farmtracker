import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/cliente_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/tables/cliente_cultura_table.dart';
import 'package:farmtracker/domains/models/cliente_cultura_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class ClienteCulturaDatabaseImpl implements ClienteCulturaLocalRepository {
  late Database db;

  @override
  AsyncResult<List<ClienteCulturaModel>> obterCulturasPorCliente(String cliente) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'cliente';
      final data = await db.query(clienteCulturaTable, where: '$whereField = ?', whereArgs: [cliente]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<ClienteCulturaModel> culturas = [];
        for (var item in result) {
          culturas.add(ClienteCulturaModel.fromJson(item));
        }
        return Success(culturas);
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<ClienteCulturaModel> obterClienteCultura(String cliente, String cultura) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String clienteField = 'cliente';
      String culturaField = 'cultura';
      final data = await db.query(
        clienteCulturaTable,
        where: '$clienteField = ? and $culturaField = ?',
        whereArgs: [cliente, cultura],
      );
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        ).first;

        return Success(ClienteCulturaModel.fromJson(result));
      }
      return Failure(NotFoundDataBaseError(errorCode: 1));
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(ClienteCulturaModel culturaCliente) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.insert(clienteCulturaTable, culturaCliente.toJson());
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(ClienteCulturaModel culturaCliente) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        clienteCulturaTable,
        culturaCliente.toJson(),
        where: 'cliente = ? and cultura = ? and lote = ? and projeto = ?',
        whereArgs: [culturaCliente.cliente, culturaCliente.cultura, culturaCliente.lote, culturaCliente.projeto],
      );
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }
}
