import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/sql/wallet_database_impl.dart';
import 'package:farmtracker/databases/local/tables/wallet_database_table.dart';
import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late _InMemoryWalletDatabase database;
  late WalletDatabaseImpl repository;

  final walletFixture = WalletModel(
    id: 'wallet-001',
    name: 'Carteira Principal',
    description: 'Carteira de clientes da região sul',
    owner: 'user-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  setUp(() {
    database = _InMemoryWalletDatabase();
    repository = WalletDatabaseImpl(databaseProvider: () async => database);
  });

  group('WalletDatabaseImpl', () {
    test('gravar persiste wallet na wallet_table', () async {
      final result = await repository.gravar(walletFixture);

      expect(result.isSuccess(), isTrue);
      expect(database.rows, hasLength(1));
      expect(database.rows.first['name'], 'Carteira Principal');
    });

    test('wallets retorna lista ordenada por name', () async {
      await repository.gravar(walletFixture);
      await repository.gravar(walletFixture.copyWith(id: 'wallet-002', name: 'Alpha Carteira'));

      final result = await repository.wallets();

      expect(result.isSuccess(), isTrue);
      result.fold(
        (wallets) {
          expect(wallets, hasLength(2));
          expect(wallets.first.name, 'Alpha Carteira');
          expect(wallets.last.name, 'Carteira Principal');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorOwner filtra por owner', () async {
      await repository.gravar(walletFixture);
      await repository.gravar(walletFixture.copyWith(id: 'wallet-002', owner: 'user-002'));

      final result = await repository.obterPorOwner('user-001');

      result.fold(
        (wallets) {
          expect(wallets, hasLength(1));
          expect(wallets.first.owner, 'user-001');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna wallet pelo id', () async {
      await repository.gravar(walletFixture);

      final result = await repository.obterPorId('wallet-001');

      result.fold(
        (wallet) {
          expect(wallet.id, 'wallet-001');
          expect(wallet.name, 'Carteira Principal');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna NotFoundDataBaseError quando wallet não existe', () async {
      final result = await repository.obterPorId('wallet-999');

      expect(result.isError(), isTrue);
      result.fold(
        (_) => fail('Esperava falha'),
        (failure) => expect(failure, isA<NotFoundDataBaseError>()),
      );
    });

    test('alterar atualiza registro existente', () async {
      await repository.gravar(walletFixture);

      final result = await repository.alterar(walletFixture.copyWith(name: 'Carteira Atualizada'));

      expect(result.isSuccess(), isTrue);
      expect(database.rows.first['name'], 'Carteira Atualizada');
    });
  });
}

class _InMemoryWalletDatabase implements Database {
  final List<Map<String, Object?>> rows = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<int> insert(String table, Map<String, Object?> values, {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) async {
    rows.add(Map<String, Object?>.from(values));
    return 1;
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    expect(table, walletTable);

    Iterable<Map<String, Object?>> filtered = rows;

    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['id'] == whereArgs.first);
    }

    if (where == 'owner = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['owner'] == whereArgs.first);
    }

    final result = filtered.map((row) => Map<String, Object?>.from(row)).toList();

    if (orderBy == 'name') {
      result.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    }

    return result;
  }

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      final index = rows.indexWhere((row) => row['id'] == whereArgs.first);
      if (index == -1) return 0;
      rows[index] = Map<String, Object?>.from(values);
      return 1;
    }
    return 0;
  }
}
