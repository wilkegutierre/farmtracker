const addressTable = 'address_table';

class AddressTable {
  String get create =>
      '''
    CREATE TABLE $addressTable (
      id TEXT PRIMARY KEY NOT NULL,
      org_owner TEXT,
      owner TEXT,
      street TEXT,
      number TEXT,
      district TEXT,
      city TEXT,
      state TEXT,
      uf TEXT,
      zip_code TEXT,
      country TEXT,
      reference TEXT,
      complement TEXT,
      lat REAL,
      longitude REAL,
      created_at TEXT,
      updated_at TEXT,
      created_by TEXT
    );
  ''';
}
