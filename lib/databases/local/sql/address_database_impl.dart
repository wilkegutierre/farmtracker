import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/address_local_repository.dart';
import 'package:farmtracker/databases/local/tables/address_table.dart';
import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class AddressDatabaseImpl implements AddressLocalRepository {
  final Future<Database> Function()? _databaseProvider;

  AddressDatabaseImpl({Future<Database> Function()? databaseProvider}) : _databaseProvider = databaseProvider;

  late Database db;

  @override
  AsyncResult<List<AddressResponseModel>> addresses() async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(addressTable, orderBy: 'city');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<AddressResponseModel> obterPorId(String id) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(addressTable, where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return Success(AddressResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<AddressResponseModel>> obterPorOwner(String owner) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(addressTable, where: 'owner = ?', whereArgs: [owner], orderBy: 'city');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<AddressResponseModel>> obterPorOrgOwner(String orgOwner) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(addressTable, where: 'org_owner = ?', whereArgs: [orgOwner], orderBy: 'city');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(AddressResponseModel address) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      await db.insert(addressTable, address.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(AddressResponseModel address) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(addressTable, address.toJson(), where: 'id = ?', whereArgs: [address.id]);
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<AddressResponseModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => AddressResponseModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
