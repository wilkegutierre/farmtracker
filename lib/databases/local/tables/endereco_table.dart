const enderecoTable = 'endereco_table';

class EnderecoTable {
  String get create => '''
  create table $enderecoTable (
    uuid text not null,
    pessoa text not null,
    logradouro text not null,
    bairro text not null,
    cidade text not null,
    uf text not null,
    cep text not null,
    numero int not null,
    complemento text,
    principal int not null,
    primary key (uuid, pessoa)
  );
''';
}
