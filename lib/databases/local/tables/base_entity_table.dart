const baseEntityTable = 'base_entity_table';

class BaseEntityTable {
  String get create =>
      '''
    CREATE TABLE $baseEntityTable (
      id TEXT,
      orgOwner TEXT NOT NULL,
      name TEXT,
      type TEXT,
      docNumber TEXT,
      createdAt TEXT,
      updatedAt TEXT,
      createdBy TEXT,
      PRIMARY KEY (id, orgOwner)
    );
  ''';
}
