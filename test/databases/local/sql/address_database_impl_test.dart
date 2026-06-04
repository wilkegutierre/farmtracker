import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/sql/address_database_impl.dart';
import 'package:farmtracker/databases/local/tables/address_table.dart';
import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late _InMemoryAddressDatabase database;
  late AddressDatabaseImpl repository;

  final addressFixture = AddressResponseModel(
    id: 'address-001',
    orgOwner: 'org-001',
    owner: 'customer-001',
    street: 'Rua das Flores',
    city: 'Ribeirão Preto',
    uf: 'SP',
    lat: -21.1775,
    longitude: -47.8103,
  );

  setUp(() {
    database = _InMemoryAddressDatabase();
    repository = AddressDatabaseImpl(databaseProvider: () async => database);
  });

  group('AddressDatabaseImpl', () {
    test('gravar persiste address na address_table', () async {
      final result = await repository.gravar(addressFixture);

      expect(result.isSuccess(), isTrue);
      expect(database.rows, hasLength(1));
      expect(database.rows.first['city'], 'Ribeirão Preto');
    });

    test('addresses retorna lista ordenada por city', () async {
      await repository.gravar(addressFixture);
      await repository.gravar(addressFixture.copyWith(id: 'address-002', city: 'Campinas'));

      final result = await repository.addresses();

      expect(result.isSuccess(), isTrue);
      result.fold(
        (addresses) {
          expect(addresses, hasLength(2));
          expect(addresses.first.city, 'Campinas');
          expect(addresses.last.city, 'Ribeirão Preto');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorOwner filtra por owner', () async {
      await repository.gravar(addressFixture);
      await repository.gravar(addressFixture.copyWith(id: 'address-002', owner: 'customer-002'));

      final result = await repository.obterPorOwner('customer-001');

      result.fold(
        (addresses) {
          expect(addresses, hasLength(1));
          expect(addresses.first.owner, 'customer-001');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorOrgOwner filtra por org_owner', () async {
      await repository.gravar(addressFixture);
      await repository.gravar(addressFixture.copyWith(id: 'address-002', orgOwner: 'org-002'));

      final result = await repository.obterPorOrgOwner('org-001');

      result.fold(
        (addresses) {
          expect(addresses, hasLength(1));
          expect(addresses.first.orgOwner, 'org-001');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna address pelo id', () async {
      await repository.gravar(addressFixture);

      final result = await repository.obterPorId('address-001');

      result.fold(
        (address) {
          expect(address.id, 'address-001');
          expect(address.city, 'Ribeirão Preto');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna NotFoundDataBaseError quando address não existe', () async {
      final result = await repository.obterPorId('address-999');

      expect(result.isError(), isTrue);
      result.fold(
        (_) => fail('Esperava falha'),
        (failure) => expect(failure, isA<NotFoundDataBaseError>()),
      );
    });

    test('alterar atualiza registro existente', () async {
      await repository.gravar(addressFixture);

      final result = await repository.alterar(addressFixture.copyWith(street: 'Av. Brasil'));

      expect(result.isSuccess(), isTrue);
      expect(database.rows.first['street'], 'Av. Brasil');
    });
  });
}

class _InMemoryAddressDatabase implements Database {
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
    expect(table, addressTable);

    Iterable<Map<String, Object?>> filtered = rows;

    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['id'] == whereArgs.first);
    }

    if (where == 'owner = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['owner'] == whereArgs.first);
    }

    if (where == 'org_owner = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['org_owner'] == whereArgs.first);
    }

    final result = filtered.map((row) => Map<String, Object?>.from(row)).toList();

    if (orderBy == 'city') {
      result.sort((a, b) => (a['city'] as String? ?? '').compareTo(b['city'] as String? ?? ''));
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
