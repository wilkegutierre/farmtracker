const projetoTable = 'projeto_table';

class ProjetoTable {
  String get create => '''
  create table $projetoTable (
    uuid text not null,
    clienteId text not null,
    nome text not null,
    descricao text not null,
    primary key (uuid, clienteId)  
  )
''';
}
