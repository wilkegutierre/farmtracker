import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/wallet_local_repository.dart';
import 'package:farmtracker/databases/local/tables/wallet_database_table.dart';
import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class WalletDatabaseImpl implements WalletLocalRepository {
  final Future<Database> Function()? _databaseProvider;

  WalletDatabaseImpl({Future<Database> Function()? databaseProvider}) : _databaseProvider = databaseProvider;

  Future<Database> _getDatabase() async {
    final provider = _databaseProvider;
    if (provider != null) {
      return provider();
    }
    return FarmTrackerDatabase.instance.dataBase;
  }

  @override
  AsyncResult<List<WalletModel>> wallets() async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(walletTable, orderBy: 'name');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<WalletModel> obterPorId(String id) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(walletTable, where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return Success(WalletModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<WalletModel>> obterPorOwner(String owner) async {
    try {
      final Database db = await _getDatabase();
      final data = await db.query(walletTable, where: 'owner = ?', whereArgs: [owner], orderBy: 'name');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(WalletModel wallet) async {
    try {
      final Database db = await _getDatabase();
      await db.insert(walletTable, wallet.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(WalletModel wallet) async {
    try {
      final Database db = await _getDatabase();
      final result = await db.update(
        walletTable,
        wallet.toJson(),
        where: 'id = ?',
        whereArgs: [wallet.id],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<WalletModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => WalletModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
