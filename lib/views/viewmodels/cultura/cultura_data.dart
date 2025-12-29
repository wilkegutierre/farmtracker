import 'package:farmtracker/domains/models/cliente_cultura_model.dart';
import 'package:farmtracker/domains/models/cultura_model.dart';

class CulturaData {
  CulturaModel? cultura;
  List<CulturaModel>? culturas = [];
  List<CulturaModel>? culturasAreaCliente = [];
  List<ClienteCulturaModel> relacaoClienteCulturas = [];
  String? projetoLote;
}
