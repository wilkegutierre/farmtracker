import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/sql/crop_database_impl.dart';
import 'package:farmtracker/databases/local/tables/crop_table.dart';
import 'package:farmtracker/domains/models/crop_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late _InMemoryCropDatabase database;
  late CropDatabaseImpl repository;

  final cropFixture = CropModel(
    id: 'crop-001',
    name: 'Soja',
    orgOwner: 'org-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  setUp(() {
    database = _InMemoryCropDatabase();
    repository = CropDatabaseImpl(databaseProvider: () async => database);
  });

  group('CropDatabaseImpl', () {
    test('gravar persiste crop na crop_table', () async {
      final result = await repository.gravar(cropFixture);

      expect(result.isSuccess(), isTrue);
      expect(database.rows, hasLength(1));
      expect(database.rows.first['name'], 'Soja');
    });

    test('crops retorna lista ordenada por name', () async {
      await repository.gravar(cropFixture);
      await repository.gravar(cropFixture.copyWith(id: 'crop-002', name: 'Milho'));

      final result = await repository.crops();

      expect(result.isSuccess(), isTrue);
      result.fold(
        (crops) {
          expect(crops, hasLength(2));
          expect(crops.first.name, 'Milho');
          expect(crops.last.name, 'Soja');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorName filtra por prefixo do name', () async {
      await repository.gravar(cropFixture);
      await repository.gravar(cropFixture.copyWith(id: 'crop-002', name: 'Milho'));

      final result = await repository.obterPorName('So');

      result.fold(
        (crops) {
          expect(crops, hasLength(1));
          expect(crops.first.name, 'Soja');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna crop pela chave composta id + org_owner', () async {
      await repository.gravar(cropFixture);

      final result = await repository.obterPorId('crop-001', 'org-001');

      result.fold(
        (crop) {
          expect(crop.id, 'crop-001');
          expect(crop.orgOwner, 'org-001');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna NotFoundDataBaseError quando crop não existe', () async {
      final result = await repository.obterPorId('crop-999', 'org-001');

      expect(result.isError(), isTrue);
      result.fold(
        (_) => fail('Esperava falha'),
        (failure) => expect(failure, isA<NotFoundDataBaseError>()),
      );
    });

    test('alterar atualiza registro existente', () async {
      await repository.gravar(cropFixture);

      final result = await repository.alterar(cropFixture.copyWith(name: 'Soja RR'));

      expect(result.isSuccess(), isTrue);
      expect(database.rows.first['name'], 'Soja RR');
    });
  });
}

class _InMemoryCropDatabase implements Database {
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
    expect(table, cropTable);

    Iterable<Map<String, Object?>> filtered = rows;

    if (where == 'name like ?' && whereArgs != null && whereArgs.isNotEmpty) {
      final prefix = whereArgs.first as String;
      filtered = filtered.where((row) => (row['name'] as String).startsWith(prefix.replaceAll('%', '')));
    }

    if (where == 'id = ? and org_owner = ?' && whereArgs != null && whereArgs.length == 2) {
      filtered = filtered.where((row) => row['id'] == whereArgs[0] && row['org_owner'] == whereArgs[1]);
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
    if (where == 'id = ? and org_owner = ?' && whereArgs != null && whereArgs.length == 2) {
      final index = rows.indexWhere((row) => row['id'] == whereArgs[0] && row['org_owner'] == whereArgs[1]);
      if (index == -1) return 0;
      rows[index] = Map<String, Object?>.from(values);
      return 1;
    }
    return 0;
  }
}
