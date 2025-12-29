import 'package:farmtracker/databases/models/response/lote_cultura_response_model.dart';

class LoteCulturaResponseModelMock {
  static LoteCulturaResponseModel getMockLoteCultura1() {
    return LoteCulturaResponseModel(
      loteId: '123e4567-e89b-12d3-a456-426614174000',
      culturaId: '789abcde-f123-45d6-a789-426614174000',
      areaCultura: 100.0,
    );
  }

  static LoteCulturaResponseModel getMockLoteCultura2() {
    return LoteCulturaResponseModel(
      loteId: '123e4567-e89b-12d3-a456-426614174002',
      culturaId: '789abcde-f123-45d6-a789-426614174001',
      areaCultura: 150.0,
    );
  }

  static LoteCulturaResponseModel getMockLoteCultura3() {
    return LoteCulturaResponseModel(
      loteId: '123e4567-e89b-12d3-a456-426614174003',
      culturaId: '789abcde-f123-45d6-a789-426614174002',
      areaCultura: 180.0,
    );
  }

  static List<LoteCulturaResponseModel> getMockLoteCulturas() {
    return [
      LoteCulturaResponseModel(
        loteId: '123e4567-e89b-12d3-a456-426614174000',
        culturaId: '789abcde-f123-45d6-a789-426614174000',
        areaCultura: 150.0,
      ),
      LoteCulturaResponseModel(
        loteId: '123e4567-e89b-12d3-a456-426614174002',
        culturaId: '789abcde-f123-45d6-a789-426614174001',
        areaCultura: 200.0,
      ),
      LoteCulturaResponseModel(
        loteId: '123e4567-e89b-12d3-a456-426614174003',
        culturaId: '789abcde-f123-45d6-a789-426614174002',
        areaCultura: 180.0,
      ),
    ];
  }
}
