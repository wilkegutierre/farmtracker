const userTable = 'user_table';

class UserTable {
  String get create =>
      '''
    CREATE TABLE $userTable (
      id TEXT,
      email TEXT,
      phone TEXT,
      addressId TEXT,
      FOREIGN KEY (addressId) REFERENCES address_table (id) ON DELETE SET NULL,
      PRIMARY KEY (id)
    );
  ''';
}
