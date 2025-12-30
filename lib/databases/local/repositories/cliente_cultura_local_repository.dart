import 'package:farmtracker/domains/models/cliente_cultura_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ClienteCulturaLocalRepository {
  AsyncResult<List<ClienteCulturaModel>> obterCulturasPorCliente(String cliente);
  AsyncResult<ClienteCulturaModel> obterClienteCultura(String cliente, String cultura);
  AsyncResult<bool> gravar(ClienteCulturaModel cliente);
  AsyncResult<bool> alterar(ClienteCulturaModel culturaCliente);
}
