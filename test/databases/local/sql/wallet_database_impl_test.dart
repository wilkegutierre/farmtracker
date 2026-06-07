import 'package:farmtracker/databases/local/repositories/wallet_local_repository.dart';
import 'package:farmtracker/databases/local/sql/wallet_database_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('WalletDatabaseImpl implementa WalletLocalRepository', () {
    expect(WalletDatabaseImpl(), isA<WalletLocalRepository>());
  });
}
