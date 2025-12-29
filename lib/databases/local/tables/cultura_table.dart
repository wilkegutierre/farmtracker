const culturaTable = 'cultura_table';

class CulturaTable {
  String get create => '''
  create table $culturaTable (
    uuid text not null,
    nome text not null,
    descricao text not null,
    urlImagem text not null,
    primary key (uuid)
  );
''';
}
