const organizationTable = 'organization_table';

class OrganizationTable {
  String get create =>
      '''
    CREATE TABLE $organizationTable (
  id TEXT PRIMARY KEY,
  description TEXT,
  address_id TEXT NOT NULL
);
''';
}
