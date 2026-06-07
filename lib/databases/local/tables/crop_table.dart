const cropTable = 'crop_table';

class CropTable {
  String get create =>
      '''
    CREATE TABLE $cropTable (
      id TEXT,
      name TEXT NOT NULL,
      orgOwner TEXT NOT NULL,
      createdAt TEXT,
      updatedAt TEXT,
      createdBy TEXT,
      PRIMARY KEY (id, orgOwner)
    )
  ''';
}
