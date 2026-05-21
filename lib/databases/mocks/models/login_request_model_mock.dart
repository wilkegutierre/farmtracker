import 'package:farmtracker/databases/models/request/login_user_request_model.dart';

LoginUserRequestModel getMockLoginRequest() =>
    LoginUserRequestModel(email: 'usuario.teste@email.com', password: 'senha123');
