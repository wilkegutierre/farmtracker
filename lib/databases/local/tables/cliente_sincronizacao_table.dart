const clienteSincronizacaoTable = 'cliente_sincronizacao_table';

class ClienteSincronizacaoTable {
  String get create => '''
  create table $clienteSincronizacaoTable (
    id integer primary key autoincrement,
    data_sincronizacao integer not null
  );
''';
}
