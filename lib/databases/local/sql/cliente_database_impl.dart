import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/cliente_local_repository.dart';
import 'package:farmtracker/databases/local/tables/cliente_table.dart';
import 'package:farmtracker/databases/mocks/models/cliente_response_model_mock.dart';
import 'package:farmtracker/databases/models/response/cliente_response_model.dart';
import 'package:farmtracker/domains/models/cliente_model.dart';
import 'package:farmtracker/domains/models/cliente_request_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class ClienteDatabaseImpl implements ClienteLocalRepository {
  late Database db;

  @override
  AsyncResult<ClienteResponseModel> getClientePorNome(String nome) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'nome';
      final data = await db.query(clienteTable, where: '$whereField = ?', whereArgs: [nome]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        ).first;
        //return Success(ClienteResponseModel.fromJson(result));
        return Success(getMockCliente());
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<ClienteResponseModel> getClientePorUuid(String uuid) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'uuid';
      final data = await db.query(clienteTable, where: '$whereField = ?', whereArgs: [uuid]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        ).first;
        //return Success(ClienteResponseModel.fromJson(result));
        return Success(getMockCliente());
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<ClienteModel>> getClientes() async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(clienteTable, orderBy: 'nome');
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<ClienteModel> clientes = [];
        for (var item in result as List) {
          clientes.add(ClienteModel.fromJson(item));
        }
        return Success(clientes);
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(ClienteModel cliente) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      ClienteRequestModel clienteRequestModel = cliente.toRequestModel();
      await db.insert(clienteTable, clienteRequestModel.toJson());
      return const Success(true);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> atualizar(ClienteModel cliente) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      ClienteRequestModel clienteRequestModel = cliente.toRequestModel();
      final result = await db.update(
        clienteTable,
        clienteRequestModel.toJson(),
        where: 'uuid = ?',
        whereArgs: [cliente.uuid],
      );
      return Success(result == 1 ? true : false);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }
}
