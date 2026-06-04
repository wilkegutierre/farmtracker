const userTable = 'user_table';

class UserTable {
  String get create =>
      '''
    CREATE TABLE $userTable (
      id TEXT PRIMARY KEY NOT NULL,
      email TEXT,
      phone TEXT,
      address_id TEXT,
      FOREIGN KEY (address_id) REFERENCES address_table (id) ON DELETE SET NULL
    );
  ''';
}
