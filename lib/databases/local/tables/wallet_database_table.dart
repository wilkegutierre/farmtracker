const walletTable = 'wallet_table';

class WalletTable {
  String get create =>
      '''
    CREATE TABLE $walletTable (
      id TEXT PRIMARY KEY NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      owner TEXT,
      created_at TEXT,
      updated_at TEXT,
      created_by TEXT,
      FOREIGN KEY (owner) REFERENCES users (id) ON DELETE SET NULL
    );
  ''';
}
