import 'package:farmtracker/databases/models/request/login_user_request_model.dart';

LoginUserRequestModel getMockLoginRequest() =>
    LoginUserRequestModel(login: 'usuario.teste@email.com', password: 'senha123');
