const loginTable = 'login_table';

class LoginTable {
  String get create => '''
  create table $loginTable (
    usuario text not null,
    dataLogin text not null,
  );
''';
}
