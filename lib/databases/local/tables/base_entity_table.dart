const baseEntityTable = 'base_entity_table';

class BaseEntityTable {
  String get create =>
      '''
    CREATE TABLE $baseEntityTable (
      id TEXT PRIMARY KEY NOT NULL,
      org_owner TEXT NOT NULL,
      name TEXT,
      type TEXT,
      doc_number TEXT,
      created_at TEXT,
      updated_at TEXT,
      created_by TEXT
    );
  ''';
}
