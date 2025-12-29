const agendaExecucaoTable = 'agenda_execucao_table';

class AgendaExecucaoTable {
  String get create => '''
    create table $agendaExecucaoTable (
      uuid text not null,
      agenda text not null,
      dataHora text not null,
      descricao text not null,
      pragaExistente text,
      kmAtendimento text,
      observacao text,
      primary key (uuid, agenda)
    );
''';
}
