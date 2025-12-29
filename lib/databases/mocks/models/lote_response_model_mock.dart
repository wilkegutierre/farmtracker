import 'package:farmtracker/databases/mocks/models/lote_cultura_response_model_mock.dart';
import 'package:farmtracker/databases/models/response/lote_response_model.dart';

class LoteResponseModelMock {
  static LoteResponseModel getMockLote1() {
    return LoteResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174000',
      nome: 'Lote A',
      descricao: 'Descrição do lote A',
      culturas: [
        LoteCulturaResponseModelMock.getMockLoteCultura1(),
        LoteCulturaResponseModelMock.getMockLoteCultura2(),
      ],
    );
  }

  static LoteResponseModel getMockLote2() {
    return LoteResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174001',
      nome: 'Lote A',
      descricao: 'Descrição do lote A',
      culturas: [LoteCulturaResponseModelMock.getMockLoteCultura1()],
    );
  }

  static LoteResponseModel getMockLote3() {
    return LoteResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174002',
      nome: 'Lote B',
      descricao: 'Descrição do lote B',
      culturas: [LoteCulturaResponseModelMock.getMockLoteCultura2()],
    );
  }

  static LoteResponseModel getMockLote4() {
    return LoteResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174003',
      nome: 'Lote C',
      descricao: 'Descrição do lote C',
      culturas: [LoteCulturaResponseModelMock.getMockLoteCultura3()],
    );
  }

  static List<LoteResponseModel> getMockLotes() {
    return [getMockLote1(), getMockLote2(), getMockLote3(), getMockLote4()];
  }
}
