const agendaTable = 'agenda_table';

class AgendaTable {
  String get create => '''
    create table $agendaTable (
      uuid text not null,
      usuario text not null,
      cliente text not null,
      dataHoraCriacao text not null,
      descricao text not null,
      motivo text not null,
      situacao int not null,
      observacao text,
      primary key (uuid, usuario)
    );
''';
}
