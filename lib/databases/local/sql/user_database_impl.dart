import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/user_local_repository.dart';
import 'package:farmtracker/databases/local/tables/user_table.dart';
import 'package:farmtracker/databases/models/response/user_response_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabaseImpl implements UserLocalRepository {
  final Future<Database> Function()? _databaseProvider;

  UserDatabaseImpl({Future<Database> Function()? databaseProvider}) : _databaseProvider = databaseProvider;

  Future<Database> _getDatabase() async {
    final provider = _databaseProvider;
    if (provider != null) {
      return provider();
    }
    return FarmTrackerDatabase.instance.dataBase;
  }

  @override
  AsyncResult<List<UserResponseModel>> users() async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(userTable, orderBy: 'email');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<UserResponseModel> obterPorId(String id) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(userTable, where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return Success(UserResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<UserResponseModel> obterPorEmail(String email) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(userTable, where: 'email = ?', whereArgs: [email]);
      if (data.isNotEmpty) {
        return Success(UserResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<UserResponseModel>> obterPorAddressId(String addressId) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(
        userTable,
        where: 'address_id = ?',
        whereArgs: [addressId],
        orderBy: 'email',
      );
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(UserResponseModel user) async {
    try {
      final Database db = await _getDatabase();
      await db.insert(userTable, user.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(UserResponseModel user) async {
    try {
      final Database db = await _getDatabase();
      final result = await db.update(
        userTable,
        user.toJson(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<UserResponseModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => UserResponseModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
