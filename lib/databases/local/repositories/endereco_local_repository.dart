import 'package:farmtracker/domains/models/endereco_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class EnderecoLocalRepository {
  AsyncResult<bool> gravar(EnderecoModel motivoAgenda);
  AsyncResult<bool> atualizar(EnderecoModel motivoAgenda);
  AsyncResult<List<EnderecoModel>> obterPorLogradouro(String logradouro);
  AsyncResult<List<EnderecoModel>> obterPorCliente(String cliente);
  AsyncResult<EnderecoModel> obterPorUuid(String uuid);
}
