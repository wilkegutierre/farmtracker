import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/sql/customer_database_impl.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late _InMemoryCustomerDatabase database;
  late CustomerDatabaseImpl repository;

  final customerFixture = CustomerResponseModel(
    id: 'customer-001',
    proprietario: 'João Silva',
    responsavelTechnico: 'Dr. Pedro',
    email: 'fazenda@test.com',
    orgOwner: 'org-001',
  );

  setUp(() {
    database = _InMemoryCustomerDatabase();
    repository = CustomerDatabaseImpl(databaseProvider: () async => database);
  });

  group('CustomerDatabaseImpl', () {
    test('gravar persiste customer na cliente_table', () async {
      final result = await repository.gravar(customerFixture);

      expect(result.isSuccess(), isTrue);
      expect(database.rows, hasLength(1));
      expect(database.rows.first['email'], 'fazenda@test.com');
    });

    test('customers retorna lista ordenada por email', () async {
      await repository.gravar(customerFixture);
      await repository.gravar(customerFixture.copyWith(id: 'customer-002', email: 'alpha@test.com'));

      final result = await repository.customers();

      expect(result.isSuccess(), isTrue);
      result.fold((customers) {
        expect(customers, hasLength(2));
        expect(customers.first.email, 'alpha@test.com');
        expect(customers.last.email, 'fazenda@test.com');
      }, (_) => fail('Esperava sucesso'));
    });

    test('obterPorOrgOwner filtra por org_owner', () async {
      await repository.gravar(customerFixture);
      await repository.gravar(customerFixture.copyWith(id: 'customer-002', orgOwner: 'org-002'));

      final result = await repository.obterPorOrgOwner('org-001');

      result.fold((customers) {
        expect(customers, hasLength(1));
        expect(customers.first.orgOwner, 'org-001');
      }, (_) => fail('Esperava sucesso'));
    });

    test('obterPorId retorna customer pelo id', () async {
      await repository.gravar(customerFixture);

      final result = await repository.obterPorId('customer-001');

      result.fold((customer) {
        expect(customer.id, 'customer-001');
        expect(customer.email, 'fazenda@test.com');
      }, (_) => fail('Esperava sucesso'));
    });

    test('obterPorId retorna NotFoundDataBaseError quando customer não existe', () async {
      final result = await repository.obterPorId('customer-999');

      expect(result.isError(), isTrue);
      result.fold((_) => fail('Esperava falha'), (failure) => expect(failure, isA<NotFoundDataBaseError>()));
    });

    test('alterar atualiza registro existente', () async {
      await repository.gravar(customerFixture);

      final result = await repository.alterar(customerFixture.copyWith(email: 'novo@test.com'));

      expect(result.isSuccess(), isTrue);
      expect(database.rows.first['email'], 'novo@test.com');
    });
  });
}

class _InMemoryCustomerDatabase implements Database {
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
    expect(table, 'customer');

    Iterable<Map<String, Object?>> filtered = rows;

    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['id'] == whereArgs.first);
    }

    if (where == 'org_owner = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      filtered = filtered.where((row) => row['org_owner'] == whereArgs.first);
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
