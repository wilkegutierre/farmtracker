const motivoAgendaTable = 'motivo_agenda_table';

class MotivoAgendaTable {
  String get create => '''
  create table $motivoAgendaTable (
    uuid text not null,
    nome text not null,
    descricao text,
    primary key (uuid)
  );
''';
}
