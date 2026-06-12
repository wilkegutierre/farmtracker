const typeVisitTable = 'type_visit_table';

class TypeVisitTable {
  String get create =>
      '''
    CREATE TABLE $typeVisitTable (
      id INTEGER NOT NULL,
      description TEXT NOT NULL,
      orgOwner TEXT NOT NULL,
      createdAt TEXT,
      updatedAt TEXT,
      createdBy TEXT,
      PRIMARY KEY (id, orgOwner)
    );
  ''';
}
