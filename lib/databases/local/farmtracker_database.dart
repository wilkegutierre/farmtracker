import 'package:farmtracker/databases/local/tables/agenda_execucao_table.dart';
import 'package:farmtracker/databases/local/tables/agenda_table.dart';
import 'package:farmtracker/databases/local/tables/cliente_cultura_table.dart';
import 'package:farmtracker/databases/local/tables/cliente_sincronizacao_table.dart';
import 'package:farmtracker/databases/local/tables/cliente_table.dart';
import 'package:farmtracker/databases/local/tables/cultura_table.dart';
import 'package:farmtracker/databases/local/tables/endereco_table.dart';
import 'package:farmtracker/databases/local/tables/lote_cultura_table.dart';
import 'package:farmtracker/databases/local/tables/lote_table.dart';
import 'package:farmtracker/databases/local/tables/motivo_agenda_table.dart';
import 'package:farmtracker/databases/local/tables/projeto_table.dart';
import 'package:farmtracker/databases/local/tables/usuario_table.dart';
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
      onUpgrade: _onUpgradeDataBase,
    );
  }

  _onCreateDataBase(db, version) async {
    await db.execute(AgendaTable().create);
    await db.execute(AgendaExecucaoTable().create);
    await db.execute(ClienteCulturaTable().create);
    await db.execute(ClienteTable().create);
    await db.execute(CulturaTable().create);
    await db.execute(EnderecoTable().create);
    await db.execute(MotivoAgendaTable().create);
    await db.execute(UsuarioTable().create);
    await db.execute(ProjetoTable().create);
    await db.execute(LoteTable().create);
    await db.execute(LoteCulturaTable().create);
    await db.execute(ClienteSincronizacaoTable().create);
  }

  Future<void> _onUpgradeDataBase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(ClienteSincronizacaoTable().create);
    }
  }
}
