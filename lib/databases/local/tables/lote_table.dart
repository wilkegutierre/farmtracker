const loteTable = 'lote_table';

class LoteTable {
  String get create => '''
  create table $loteTable (
  uuid text not null,
  projetoId text not null,
  nome text not null,
  descricao text not null,
  primary key (uuid, projetoId)
  )
''';
}
