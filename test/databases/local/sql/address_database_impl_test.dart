import 'package:farmtracker/databases/local/repositories/address_local_repository.dart';
import 'package:farmtracker/databases/local/sql/address_database_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AddressDatabaseImpl implementa AddressLocalRepository', () {
    expect(AddressDatabaseImpl(), isA<AddressLocalRepository>());
  });
}
