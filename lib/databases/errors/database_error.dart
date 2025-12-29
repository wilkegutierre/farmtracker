import 'app_failure_interface.dart';

abstract class DataBaseError extends AppFailure {
  final int? errorCode;

  DataBaseError({this.errorCode, required super.message});
}

class SearchDataBaseError extends DataBaseError {
  SearchDataBaseError({super.errorCode, super.message = 'Falha ao buscar um dado na base!'});
}

class InsertDataBaseError extends DataBaseError {
  InsertDataBaseError({super.errorCode, super.message = 'Falha ao inserir um dado na base!'});
}

class UpdateDataBaseError extends DataBaseError {
  UpdateDataBaseError({super.errorCode, super.message = 'Falha ao atualizar um dado na base!'});
}

class DeleteDataBaseError extends DataBaseError {
  DeleteDataBaseError({super.errorCode, super.message = 'Falha ao deletar um dado da base!'});
}

class NotFoundDataBaseError extends DataBaseError {
  NotFoundDataBaseError({super.errorCode, super.message = 'Registro não encontrado na base!'});
}
