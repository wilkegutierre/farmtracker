import 'package:farmtracker/databases/local/tables/address_table.dart';
import 'package:farmtracker/databases/local/tables/base_entity_table.dart';
import 'package:farmtracker/databases/local/tables/crop_table.dart';
import 'package:farmtracker/databases/local/tables/customer_table.dart';
import 'package:farmtracker/databases/local/tables/organization_table.dart';
import 'package:farmtracker/databases/local/tables/user_table.dart';
import 'package:farmtracker/databases/local/tables/wallet_database_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FarmTrackerDatabase {
  FarmTrackerDatabase._();

  final int _version = 2;

  static final FarmTrackerDatabase instance = FarmTrackerDatabase._();
  static Database? _database;

  get dataBase async {
    if (_database != null) {
      return _database;
    }
    return await _initDataBase();
  }

  _initDataBase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'farmtracker.db'),
      version: _version,
      onCreate: _onCreateDataBase,
      //onUpgrade: _onUpgradeDataBase,
    );
  }

  _onCreateDataBase(db, version) async {
    await db.execute(UserTable().create);
    await db.execute(OrganizationTable().create);
    await db.execute(AddressTable().create);
    await db.execute(BaseEntityTable().create);
    await db.execute(WalletTable().create);
    await db.execute(CropTable().create);
    await db.execute(CustomerTable().create);

    // Future<void> _onUpgradeDataBase(Database db, int oldVersion, int newVersion) async {
    //   if (oldVersion < 2) {
    //     await db.execute(ClienteSincronizacaoTable().create);
    //   }
    // }
  }
}
