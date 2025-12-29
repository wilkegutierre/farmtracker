import 'package:farmtracker/databases/models/response/usuario_response_model.dart';

UsuarioResponseModel getMockUsuario() {
  return UsuarioResponseModel(
      uuid: '550e8400-e29b-41d4-a716-446655440000',
      nome: 'João Silva',
      email: 'joao.silva@exemplo.com',
      telefone: '(11) 99999-9999',
      senha: '123456',
      foto: 'https://exemplo.com/foto.jpg',
      tokenAcesso: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
}

List<UsuarioResponseModel> getMockUsuarioList() => [
      UsuarioResponseModel(
          uuid: '550e8400-e29b-41d4-a716-446655440000',
          nome: 'João Silva',
          email: 'joao.silva@exemplo.com',
          telefone: '(11) 99999-9999',
          senha: '123456',
          foto: 'https://exemplo.com/foto1.jpg',
          tokenAcesso: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'),
      UsuarioResponseModel(
          uuid: '550e8400-e29b-41d4-a716-446655440001',
          nome: 'Maria Santos',
          email: 'maria.santos@exemplo.com',
          telefone: '(11) 88888-8888',
          senha: '654321',
          foto: 'https://exemplo.com/foto2.jpg',
          tokenAcesso: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'),
      UsuarioResponseModel(
          uuid: '550e8400-e29b-41d4-a716-446655440002',
          nome: 'Pedro Oliveira',
          email: 'pedro.oliveira@exemplo.com',
          telefone: '(11) 77777-7777',
          senha: '987654',
          foto: 'https://exemplo.com/foto3.jpg',
          tokenAcesso: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'),
    ];
