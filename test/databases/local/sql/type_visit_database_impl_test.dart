import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/type_visit_local_repository.dart';
import 'package:farmtracker/databases/local/sql/type_visit_database_impl.dart';
import 'package:farmtracker/databases/local/tables/type_visit_table.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import 'support/in_memory_type_visit_local_repository.dart';

void main() {
  late _InMemoryTypeVisitDatabase database;
  late InMemoryTypeVisitLocalRepository repository;

  final typeVisitFixture = TypeVisitResponseModel(
    id: 1,
    description: 'Monitoramento',
    orgOwner: 'org-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  setUp(() {
    database = _InMemoryTypeVisitDatabase();
    repository = InMemoryTypeVisitLocalRepository(database);
  });

  group('TypeVisitDatabaseImpl', () {
    test('implementa TypeVisitLocalRepository', () {
      expect(TypeVisitDatabaseImpl(), isA<TypeVisitLocalRepository>());
    });
  });

  group('InMemoryTypeVisitLocalRepository', () {
    test('gravar persiste type visit na type_visit_table', () async {
      final result = await repository.gravar(typeVisitFixture);

      expect(result.isSuccess(), isTrue);
      expect(database.rows, hasLength(1));
      expect(database.rows.first['description'], 'Monitoramento');
    });

    test('typeVisits retorna lista ordenada por description', () async {
      await repository.gravar(typeVisitFixture);
      await repository.gravar(typeVisitFixture.copyWith(id: 2, description: 'Tratamento'));

      final result = await repository.typeVisits();

      expect(result.isSuccess(), isTrue);
      result.fold((typeVisits) {
        expect(typeVisits, hasLength(2));
        expect(typeVisits.first.description, 'Monitoramento');
        expect(typeVisits.last.description, 'Tratamento');
      }, (_) => fail('Esperava sucesso'));
    });

    test('obterPorId retorna type visit pela chave composta id + orgOwner', () async {
      await repository.gravar(typeVisitFixture);

      final result = await repository.obterPorId(1, 'org-001');

      result.fold((typeVisit) {
        expect(typeVisit.id, 1);
        expect(typeVisit.orgOwner, 'org-001');
        expect(typeVisit.description, 'Monitoramento');
      }, (_) => fail('Esperava sucesso'));
    });

    test('obterPorId retorna NotFoundDataBaseError quando type visit não existe', () async {
      final result = await repository.obterPorId(999, 'org-001');

      expect(result.isError(), isTrue);
      result.fold((_) => fail('Esperava falha'), (failure) => expect(failure, isA<NotFoundDataBaseError>()));
    });

    test('alterar atualiza registro existente', () async {
      await repository.gravar(typeVisitFixture);

      final result = await repository.alterar(typeVisitFixture.copyWith(description: 'Inspeção'));

      expect(result.isSuccess(), isTrue);
      expect(database.rows.first['description'], 'Inspeção');
    });
  });
}

class _InMemoryTypeVisitDatabase implements Database {
  final List<Map<String, Object?>> rows = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
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
    expect(table, typeVisitTable);

    Iterable<Map<String, Object?>> filtered = rows;

    if (where == 'id = ? AND orgOwner = ?' && whereArgs != null && whereArgs.length == 2) {
      filtered = filtered.where((row) => row['id'] == whereArgs[0] && row['orgOwner'] == whereArgs[1]);
    }

    final result = filtered.map((row) => Map<String, Object?>.from(row)).toList();

    if (orderBy == 'description') {
      result.sort((a, b) => (a['description'] as String).compareTo(b['description'] as String));
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
    if (where == 'id = ? AND orgOwner = ?' && whereArgs != null && whereArgs.length == 2) {
      final index = rows.indexWhere((row) => row['id'] == whereArgs[0] && row['orgOwner'] == whereArgs[1]);
      if (index == -1) return 0;
      rows[index] = Map<String, Object?>.from(values);
      return 1;
    }
    return 0;
  }
}
