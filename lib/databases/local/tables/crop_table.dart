const cropTable = 'crop_table';

class ProjetoTable {
  String get create =>
      '''
    CREATE TABLE $cropTable (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      org_owner TEXT NOT NULL,
      created_at TEXT,
      updated_at TEXT,
      created_by TEXT,
      PRIMARY KEY (id, org_owner)
    )
  ''';
}
