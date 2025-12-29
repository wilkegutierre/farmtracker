import 'package:farmtracker/databases/models/request/login_user_request_model.dart';

LoginUserRequestModel getMockLoginRequest() => LoginUserRequestModel(
      acesso: 'usuario.teste@email.com',
      senha: 'senha123',
    );
