const clienteTable = 'cliente_table';

class ClienteTable {
  String get create => '''
  create table $clienteTable (
    uuid text not null,
    nome text not null,
    email text not null,
    celular text not null,
    observacao text not null,
    proprietario text not null,
    responsavelTecnico text not null,
    primary key (uuid)
  );
''';
}
