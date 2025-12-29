const loteCulturaTable = 'lote_cultura_table';

class LoteCulturaTable {
  String get create => '''
  create table $loteCulturaTable (
    loteId text not null,
    culturaId text not null,
    areaCultura real not null,
    primary key (loteId, culturaId)
  )
''';
}
