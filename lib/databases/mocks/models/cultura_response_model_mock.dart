import 'package:farmtracker/databases/models/response/cultura_response_model.dart';

CulturaResponseModel getMockCultura() => CulturaResponseModel(
    uuid: '789abcde-f123-45d6-a789-426614174000',
    nome: 'Soja',
    descricao: 'Cultura de soja convencional',
    lote: '123e4567-e89b-12d3-a456-426614174002',
    urlImagem: 'https://cdn.pixabay.com/photo/2015/09/29/18/41/soy-964324_960_720.jpg');

List<CulturaResponseModel> getMockCulturas() => [
      CulturaResponseModel(
          uuid: '789abcde-f123-45d6-a789-426614174000',
          nome: 'Soja',
          descricao: 'Cultura de soja convencional',
          lote: '123e4567-e89b-12d3-a456-426614174002',
          urlImagem: 'https://cdn.pixabay.com/photo/2015/09/29/18/41/soy-964324_960_720.jpg'),
      CulturaResponseModel(
          uuid: '789abcde-f123-45d6-a789-426614174001',
          nome: 'Milho',
          descricao: 'Milho híbrido de alta produtividade',
          lote: '123e4567-e89b-12d3-a456-426614174002',
          urlImagem: 'https://cdn.pixabay.com/photo/2023/05/30/14/49/corn-8028831_960_720.jpg'),
      CulturaResponseModel(
          uuid: '789abcde-f123-45d6-a789-426614174002',
          nome: 'Manga',
          descricao: 'Algodão fibra longa',
          lote: '123e4567-e89b-12d3-a456-426614174002',
          urlImagem: 'https://cdn.pixabay.com/photo/2016/03/05/22/18/food-1239241_960_720.jpg')
    ];
