import 'package:farmtracker/databases/models/request/login_user_request_model.dart';

LoginUserRequestModel getMockLoginRequest() =>
    LoginUserRequestModel(null, 'usuario.teste@email.com', password: 'senha123');
