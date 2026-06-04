import 'package:farmtracker/databases/models/response/user_response_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class UserLocalRepository {
  AsyncResult<bool> gravar(UserResponseModel user);
  AsyncResult<bool> alterar(UserResponseModel user);
  AsyncResult<List<UserResponseModel>> users();
  AsyncResult<UserResponseModel> obterPorId(String id);
  AsyncResult<UserResponseModel> obterPorEmail(String email);
  AsyncResult<List<UserResponseModel>> obterPorAddressId(String addressId);
}
