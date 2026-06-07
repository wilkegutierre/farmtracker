import 'package:farmtracker/databases/local/repositories/user_local_repository.dart';
import 'package:farmtracker/databases/local/sql/user_database_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserDatabaseImpl implementa UserLocalRepository', () {
    expect(UserDatabaseImpl(), isA<UserLocalRepository>());
  });
}
