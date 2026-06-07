const walletTable = 'wallet_table';

class WalletTable {
  String get create =>
      '''
    CREATE TABLE $walletTable (
      id TEXT,
      name TEXT NOT NULL,
      description TEXT,
      owner TEXT,
      FOREIGN KEY (owner) REFERENCES user_table (id) ON DELETE SET NULL,
      PRIMARY KEY (id)
    );
  ''';
}
