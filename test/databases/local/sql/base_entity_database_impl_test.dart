import 'package:farmtracker/databases/local/repositories/base_entity_local_repository.dart';
import 'package:farmtracker/databases/local/sql/base_entity_database_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BaseEntityDatabaseImpl implementa BaseEntityLocalRepository', () {
    expect(BaseEntityDatabaseImpl(), isA<BaseEntityLocalRepository>());
  });
}
