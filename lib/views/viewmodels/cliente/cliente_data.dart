import 'package:farmtracker/domains/models/cliente_cultura_model.dart';
import 'package:farmtracker/domains/models/cliente_cultura_relacao_model.dart';
import 'package:farmtracker/domains/models/cliente_model.dart';
import 'package:farmtracker/domains/models/endereco_model.dart';

class ClienteData {
  ClienteModel? cliente;
  ClienteCulturaModel? clienteCultura;
  ClienteModel? clienteSelecinado;
  EnderecoModel? enderecoClienteSelecinado;
  bool isLoading = false;
  List<ClienteModel> clientes = [];
  List<ClienteCulturaModel> clienteCulturas = [];
  List<ClienteCulturaRelacaoModel> clienteCulturaRelacao = [];
  Object? state;
  String? projeto;
  String? lote;
  String? titleAppBar;
  String? subtitleAppBar;
}
