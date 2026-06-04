import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/sql/organization_database_impl.dart';
import 'package:farmtracker/databases/local/tables/organization_table.dart';
import 'package:farmtracker/databases/models/response/organization_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late _InMemoryOrganizationDatabase database;
  late OrganizationDatabaseImpl repository;

  final organizationFixture = OrganizationResponseModel(
    id: 'org-001',
    description: 'Organização Agrícola Sul',
    addressId: 'address-001',
  );

  setUp(() {
    database = _InMemoryOrganizationDatabase();
    repository = OrganizationDatabaseImpl(databaseProvider: () async => database);
  });

  group('OrganizationDatabaseImpl', () {
    test('gravar persiste organization na organization_table', () async {
      final result = await repository.gravar(organizationFixture);

      expect(result.isSuccess(), isTrue);
      expect(database.rows, hasLength(1));
      expect(database.rows.first['description'], 'Organização Agrícola Sul');
    });

    test('organizations retorna lista ordenada por description', () async {
      await repository.gravar(organizationFixture);
      await repository.gravar(organizationFixture.copyWith(id: 'org-002', description: 'Alpha Org'));

      final result = await repository.organizations();

      expect(result.isSuccess(), isTrue);
      result.fold(
        (organizations) {
          expect(organizations, hasLength(2));
          expect(organizations.first.description, 'Alpha Org');
          expect(organizations.last.description, 'Organização Agrícola Sul');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorAddressId filtra por address_id', () async {
      await repository.gravar(organizationFixture);
      await repository.gravar(organizationFixture.copyWith(id: 'org-002', addressId: 'address-002'));

      final result = await repository.obterPorAddressId('address-001');

      result.fold(
        (organizations) {
          expect(organizations, hasLength(1));
          expect(organizations.first.addressId, 'address-001');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna organization pelo id', () async {
      await repository.gravar(organizationFixture);

      final result = await repository.obterPorId('org-001');

      result.fold(
        (organization) {
          expect(organization.id, 'org-001');
          expect(organization.description, 'Organização Agrícola Sul');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna NotFoundDataBaseError quando organization não existe', () async {
      final result = await repository.obterPorId('org-999');

      expect(result.isError(), isTrue);
      result.fold(
        (_) => fail('Esperava falha'),
        (failure) => expect(failure, isA<NotFoundDataBaseError>()),
      );
    });

    test('alterar atualiza registro existente', () async {
      await repository.gravar(organizationFixture);

      final result = await repository.alterar(organizationFixture.copyWith(description: 'Org Atualizada'));

      expect(result.isSuccess(), isTrue);
      expect(database.rows.first['description'], 'Org Atualizada');
    });
  });
}

class _InMemoryOrganizationDatabase implements Database {
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
    expect(table, organizationTable);

    Iterable<Map<String, Object?>> filtered = rows;

    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['id'] == whereArgs.first);
    }

    if (where == 'address_id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['address_id'] == whereArgs.first);
    }

    final result = filtered.map((row) => Map<String, Object?>.from(row)).toList();

    if (orderBy == 'description') {
      result.sort((a, b) => (a['description'] as String? ?? '').compareTo(b['description'] as String? ?? ''));
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
