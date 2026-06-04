const clienteTable = 'cliente_table';

class ClienteTable {
  String get create =>
      '''
    CREATE TABLE $clienteTable (
      id TEXT PRIMARY KEY NOT NULL,
      proprietario TEXT,
      responsavel_technico TEXT,
      projeto TEXT,
      email TEXT,
      primary_phone TEXT,
      secondary_phone TEXT,
      customer_situation INTEGER,
      entity TEXT,
      address TEXT,
      org_owner TEXT,
      wallet_id TEXT,
      created_by TEXT,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY (entity) REFERENCES base_entity (id) ON DELETE SET NULL,
      FOREIGN KEY (address) REFERENCES address (id) ON DELETE SET NULL,
      FOREIGN KEY (wallet_id) REFERENCES wallet (id) ON DELETE SET NULL
    );
  ''';
}
