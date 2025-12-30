import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/usuario_local_repository.dart';
import 'package:farmtracker/databases/local/tables/login_table.dart';
import 'package:farmtracker/databases/local/tables/usuario_table.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/domains/models/usuario_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDatabaseImpl implements UsuarioLocalRepository {
  late Database db;

  @override
  AsyncResult<bool> login(LoginUserRequestModel loginRequest) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      await db.insert(loginTable, loginRequest.toJson());
      return const Success(true);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<UsuarioResponseModel> obterUsuarioPorEmail(String email) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'email';
      final data = await db.query(usuarioTable, where: '$whereField = ?', whereArgs: [email]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        ).first;
        return Success(UsuarioResponseModel.fromJson(result));
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravarUsuario(UsuarioModel usuario) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      await db.insert(usuarioTable, usuario.toJson());
      return const Success(true);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }
}
