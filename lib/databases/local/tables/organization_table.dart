const organizationTable = 'organization_table';

class OrganizationTable {
  String get create =>
      '''
    CREATE TABLE $organizationTable (
  id TEXT,
  description TEXT,
  addressId TEXT NOT NULL,
  PRIMARY KEY (id)
);
''';
}
