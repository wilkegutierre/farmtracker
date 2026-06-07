const customerTable = 'customer_table';

class CustomerTable {
  String get create =>
      '''
    CREATE TABLE $customerTable (
      id TEXT,
      proprietario TEXT,
      responsavelTecnico TEXT,
      projeto TEXT,
      email TEXT,
      primaryPhone TEXT,
      secondaryPhone TEXT,
      customerSituation INTEGER,
      entity TEXT,
      address TEXT,
      orgOwner TEXT,
      walletId TEXT,
      FOREIGN KEY (entity) REFERENCES base_entity (id) ON DELETE SET NULL,
      FOREIGN KEY (address) REFERENCES address (id) ON DELETE SET NULL,
      FOREIGN KEY (walletId) REFERENCES wallet (id) ON DELETE SET NULL,
      PRIMARY KEY (id, orgOwner)
    );
  ''';
}
