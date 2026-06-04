import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/sql/user_database_impl.dart';
import 'package:farmtracker/databases/local/tables/user_table.dart';
import 'package:farmtracker/databases/models/response/user_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late _InMemoryUserDatabase database;
  late UserDatabaseImpl repository;

  final userFixture = UserResponseModel(
    id: 'user-001',
    email: 'usuario@test.com',
    phone: '11999990000',
    addressId: 'address-001',
  );

  setUp(() {
    database = _InMemoryUserDatabase();
    repository = UserDatabaseImpl(databaseProvider: () async => database);
  });

  group('UserDatabaseImpl', () {
    test('gravar persiste user na user_table', () async {
      final result = await repository.gravar(userFixture);

      expect(result.isSuccess(), isTrue);
      expect(database.rows, hasLength(1));
      expect(database.rows.first['email'], 'usuario@test.com');
    });

    test('users retorna lista ordenada por email', () async {
      await repository.gravar(userFixture);
      await repository.gravar(userFixture.copyWith(id: 'user-002', email: 'alpha@test.com'));

      final result = await repository.users();

      expect(result.isSuccess(), isTrue);
      result.fold(
        (users) {
          expect(users, hasLength(2));
          expect(users.first.email, 'alpha@test.com');
          expect(users.last.email, 'usuario@test.com');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorAddressId filtra por address_id', () async {
      await repository.gravar(userFixture);
      await repository.gravar(userFixture.copyWith(id: 'user-002', addressId: 'address-002'));

      final result = await repository.obterPorAddressId('address-001');

      result.fold(
        (users) {
          expect(users, hasLength(1));
          expect(users.first.addressId, 'address-001');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorEmail retorna user pelo email', () async {
      await repository.gravar(userFixture);

      final result = await repository.obterPorEmail('usuario@test.com');

      result.fold(
        (user) {
          expect(user.id, 'user-001');
          expect(user.email, 'usuario@test.com');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna user pelo id', () async {
      await repository.gravar(userFixture);

      final result = await repository.obterPorId('user-001');

      result.fold(
        (user) {
          expect(user.id, 'user-001');
          expect(user.email, 'usuario@test.com');
        },
        (_) => fail('Esperava sucesso'),
      );
    });

    test('obterPorId retorna NotFoundDataBaseError quando user não existe', () async {
      final result = await repository.obterPorId('user-999');

      expect(result.isError(), isTrue);
      result.fold(
        (_) => fail('Esperava falha'),
        (failure) => expect(failure, isA<NotFoundDataBaseError>()),
      );
    });

    test('alterar atualiza registro existente', () async {
      await repository.gravar(userFixture);

      final result = await repository.alterar(userFixture.copyWith(phone: '11888880000'));

      expect(result.isSuccess(), isTrue);
      expect(database.rows.first['phone'], '11888880000');
    });
  });
}

class _InMemoryUserDatabase implements Database {
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
    expect(table, userTable);

    Iterable<Map<String, Object?>> filtered = rows;

    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['id'] == whereArgs.first);
    }

    if (where == 'email = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['email'] == whereArgs.first);
    }

    if (where == 'address_id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['address_id'] == whereArgs.first);
    }

    final result = filtered.map((row) => Map<String, Object?>.from(row)).toList();

    if (orderBy == 'email') {
      result.sort((a, b) => (a['email'] as String? ?? '').compareTo(b['email'] as String? ?? ''));
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
