import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/domains/models/agenda_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AgendaLocalRepository {
  AsyncResult<bool> salvar(AgendaModel agenda);
  AsyncResult<bool> atualizar(AgendaModel agenda);
  AsyncResult<List<AgendaModel>> buscarPorData(String data);
  AsyncResult<List<AgendaModel>> buscarPorSituacao(int situacao);
  AsyncResult<List<AgendaModel>> buscarPorCliente(int cliente);
}
