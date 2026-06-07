import 'package:farmtracker/databases/local/repositories/customer_local_repository.dart';
import 'package:farmtracker/databases/local/sql/customer_database_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CustomerDatabaseImpl implementa CustomerLocalRepository', () {
    expect(CustomerDatabaseImpl(), isA<CustomerLocalRepository>());
  });
}
