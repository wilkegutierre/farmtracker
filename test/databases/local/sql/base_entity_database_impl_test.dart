import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/sql/base_entity_database_impl.dart';
import 'package:farmtracker/databases/local/tables/base_entity_table.dart';
import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late _InMemoryBaseEntityDatabase database;
  late BaseEntityDatabaseImpl repository;

  final baseEntityFixture = BaseEntityResponseModel(
    id: 'entity-001',
    orgOwner: 'org-001',
    name: 'Fazenda Boa Vista',
    type: 'PJ',
    docNumber: '12345678000199',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  setUp(() {
    database = _InMemoryBaseEntityDatabase();
    repository = BaseEntityDatabaseImpl(databaseProvider: () async => database);
  });

  group('BaseEntityDatabaseImpl', () {
    test('gravar persiste base entity na base_entity_table', () async {
      final result = await repository.gravar(baseEntityFixture);

      expect(result.isSuccess(), isTrue);
      expect(database.rows, hasLength(1));
      expect(database.rows.first['name'], 'Fazenda Boa Vista');
    });

    test('baseEntities retorna lista ordenada por name', () async {
      await repository.gravar(baseEntityFixture);
      await repository.gravar(baseEntityFixture.copyWith(id: 'entity-002', name: 'Alpha Fazenda'));

      final result = await repository.baseEntities();

      expect(result.isSuccess(), isTrue);
      result.fold(
        (baseEntities) {
          expect(baseEntities, hasLength(2));
          expect(baseEntities.first.name, 'Alpha Fazenda');
          expect(baseEntities.last.name, 'Fazenda Boa Vista');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorType filtra por type', () async {
      await repository.gravar(baseEntityFixture);
      await repository.gravar(baseEntityFixture.copyWith(id: 'entity-002', type: 'PF'));

      final result = await repository.obterPorType('PJ');

      result.fold(
        (baseEntities) {
          expect(baseEntities, hasLength(1));
          expect(baseEntities.first.type, 'PJ');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorDocNumber retorna entidade pelo doc_number', () async {
      await repository.gravar(baseEntityFixture);

      final result = await repository.obterPorDocNumber('12345678000199');

      result.fold(
        (baseEntity) {
          expect(baseEntity.id, 'entity-001');
          expect(baseEntity.docNumber, '12345678000199');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna entidade pelo id', () async {
      await repository.gravar(baseEntityFixture);

      final result = await repository.obterPorId('entity-001');

      result.fold(
        (baseEntity) {
          expect(baseEntity.id, 'entity-001');
          expect(baseEntity.name, 'Fazenda Boa Vista');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna NotFoundDataBaseError quando entidade não existe', () async {
      final result = await repository.obterPorId('entity-999');

      expect(result.isError(), isTrue);
      result.fold(
        (_) => fail('Esperava falha'),
        (failure) => expect(failure, isA<NotFoundDataBaseError>()),
      );
    });

    test('alterar atualiza registro existente', () async {
      await repository.gravar(baseEntityFixture);

      final result = await repository.alterar(baseEntityFixture.copyWith(name: 'Fazenda Atualizada'));

      expect(result.isSuccess(), isTrue);
      expect(database.rows.first['name'], 'Fazenda Atualizada');
    });
  });
}

class _InMemoryBaseEntityDatabase implements Database {
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
    expect(table, baseEntityTable);

    Iterable<Map<String, Object?>> filtered = rows;

    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['id'] == whereArgs.first);
    }

    if (where == 'type = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['type'] == whereArgs.first);
    }

    if (where == 'doc_number = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['doc_number'] == whereArgs.first);
    }

    final result = filtered.map((row) => Map<String, Object?>.from(row)).toList();

    if (orderBy == 'name') {
      result.sort((a, b) => (a['name'] as String? ?? '').compareTo(b['name'] as String? ?? ''));
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
