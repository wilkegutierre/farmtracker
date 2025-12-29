const clienteCulturaTable = 'cliente_cultura_table';

class ClienteCulturaTable {
  String get create => '''
  create table $clienteCulturaTable (
    cliente text not null,
    cultura text not null,
    area double not null,
    projeto text not null,
    lote text not null,
    primary key (cliente, cultura, projeto, lote)
  );
''';
}
