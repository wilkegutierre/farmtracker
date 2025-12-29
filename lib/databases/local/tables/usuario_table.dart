const usuarioTable = 'usuario_table';

class UsuarioTable {
  String get create => '''
    CREATE TABLE $usuarioTable (
      uuid text not null,
      nome text not null,
      email text not null,
      senha text not null,
      telefone text not null,
      urlFoto text,
      tokenAcesso text,
      primary key (uuid)
    );
''';
}
