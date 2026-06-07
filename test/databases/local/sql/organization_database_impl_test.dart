import 'package:farmtracker/databases/local/repositories/organization_local_repository.dart';
import 'package:farmtracker/databases/local/sql/organization_database_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('OrganizationDatabaseImpl implementa OrganizationLocalRepository', () {
    expect(OrganizationDatabaseImpl(), isA<OrganizationLocalRepository>());
  });
}
