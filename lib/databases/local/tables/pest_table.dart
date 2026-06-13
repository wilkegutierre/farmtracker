const pestTable = 'pest_table';

class PestTable {
  String get create =>
      '''
    CREATE TABLE $pestTable (
      id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      orgOwner TEXT NOT NULL,
      PRIMARY KEY (id, orgOwner)
    );
  ''';
}
