import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/customer_local_repository.dart';
import 'package:farmtracker/databases/local/tables/cliente_table.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class CustomerDatabaseImpl implements CustomerLocalRepository {
  final Future<Database> Function()? _databaseProvider;

  CustomerDatabaseImpl({Future<Database> Function()? databaseProvider}) : _databaseProvider = databaseProvider;

  Future<Database> _getDatabase() async {
    final provider = _databaseProvider;
    if (provider != null) {
      return provider();
    }
    return FarmTrackerDatabase.instance.dataBase;
  }

  @override
  AsyncResult<List<CustomerResponseModel>> customers() async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(clienteTable, orderBy: 'email');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<CustomerResponseModel> obterPorId(String id) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(clienteTable, where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return Success(CustomerResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<CustomerResponseModel>> obterPorOrgOwner(String orgOwner) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(clienteTable, where: 'org_owner = ?', whereArgs: [orgOwner], orderBy: 'email');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(CustomerResponseModel customer) async {
    try {
      final Database db = await _getDatabase();
      await db.insert(clienteTable, customer.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(CustomerResponseModel customer) async {
    try {
      final Database db = await _getDatabase();
      final result = await db.update(clienteTable, customer.toJson(), where: 'id = ?', whereArgs: [customer.id]);
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<CustomerResponseModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => CustomerResponseModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
