const addressTable = 'address_table';

class AddressTable {
  String get create =>
      '''
    CREATE TABLE $addressTable (
      id TEXT,
      orgOwner TEXT,
      owner TEXT,
      street TEXT,
      number TEXT,
      district TEXT,
      city TEXT,
      state TEXT,
      uf TEXT,
      zipCode TEXT,
      country TEXT,
      reference TEXT,
      complement TEXT,
      lat REAL,
      longitude REAL,
      createdAt TEXT,
      updatedAt TEXT,
      createdBy TEXT,
      PRIMARY KEY (id, orgOwner)
    );
  ''';
}
