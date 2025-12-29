import 'package:farmtracker/databases/models/response/cliente_cultura_response_model.dart';

ClienteCulturaResponseModel getMockClienteCultura() => ClienteCulturaResponseModel(
      cliente: '987fcdeb-51a3-12d3-a456-426614174000', // UUID do cliente mock
      cultura: '789abcde-f123-45d6-a789-426614174000', // UUID da cultura mock (Soja)
    );

List<ClienteCulturaResponseModel> getMockClienteCulturaList() => [
      ClienteCulturaResponseModel(
        cliente: '987fcdeb-51a3-12d3-a456-426614174000',
        cultura: '789abcde-f123-45d6-a789-426614174000',
      ),
      ClienteCulturaResponseModel(
        cliente: '987fcdeb-51a3-12d3-a456-426614174000',
        cultura: '789abcde-f123-45d6-a789-426614174001', // UUID da cultura mock (Milho)
      ),
      ClienteCulturaResponseModel(
        cliente: '987fcdeb-51a3-12d3-a456-426614174000',
        cultura: '789abcde-f123-45d6-a789-426614174002', // UUID da cultura mock (Manga)
      ),
    ];
