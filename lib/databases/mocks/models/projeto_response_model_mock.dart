import 'package:farmtracker/databases/mocks/models/lote_response_model_mock.dart';
import 'package:farmtracker/databases/models/response/projeto_response_model.dart';

class ProjetoResponseModelMock {
  static ProjetoResponseModel getMockProjeto1() {
    return ProjetoResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174000',
      //clienteId: '987fcdeb-51a3-12d3-a456-426614174000',
      nome: 'Nilo Coelho',
      descricao: 'Descrição do projeto Nilo Coelho',
      lotes: [LoteResponseModelMock.getMockLote1(), LoteResponseModelMock.getMockLote2()],
    );
  }

  static ProjetoResponseModel getMockProjeto2() {
    return ProjetoResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174002',
      //clienteId: '987fcdeb-51a3-12d3-a456-426614174001',
      nome: 'Maria Tereza',
      descricao: 'Descrição do projeto Maria Tereza',
      lotes: [LoteResponseModelMock.getMockLote3(), LoteResponseModelMock.getMockLote4()],
    );
  }

  static ProjetoResponseModel getMockProjeto3() {
    return ProjetoResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174004',
      //clienteId: '987fcdeb-51a3-12d3-a456-426614174003',
      nome: 'N1',
      descricao: 'Descrição do projeto N1',
      lotes: [
        LoteResponseModelMock.getMockLote1(),
        LoteResponseModelMock.getMockLote2(),
        LoteResponseModelMock.getMockLote3(),
      ],
    );
  }

  static List<ProjetoResponseModel> getMockProjetos() {
    return [getMockProjeto1(), getMockProjeto2(), getMockProjeto3()];
  }

  static ProjetoResponseModel getMockProjeto4() {
    return ProjetoResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174006',
      //clienteId: '987fcdeb-51a3-12d3-a456-426614174004',
      nome: 'Projeto Quatro',
      descricao: 'Descrição do projeto Quatro',
      lotes: [LoteResponseModelMock.getMockLote2(), LoteResponseModelMock.getMockLote4()],
    );
  }

  static ProjetoResponseModel getMockProjeto5() {
    return ProjetoResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174008',
      //clienteId: '987fcdeb-51a3-12d3-a456-426614174005',
      nome: 'Projeto Cinco',
      descricao: 'Descrição do projeto Cinco',
      lotes: [LoteResponseModelMock.getMockLote1()],
    );
  }

  static ProjetoResponseModel getMockProjeto6() {
    return ProjetoResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174010',
      //clienteId: '987fcdeb-51a3-12d3-a456-426614174006',
      nome: 'Projeto Seis',
      descricao: 'Descrição do projeto Seis',
      lotes: [LoteResponseModelMock.getMockLote3()],
    );
  }

  static ProjetoResponseModel getMockProjeto7() {
    return ProjetoResponseModel(
      uuid: '123e4567-e89b-12d3-a456-426614174012',
      //clienteId: '987fcdeb-51a3-12d3-a456-426614174007',
      nome: 'Projeto Sete',
      descricao: 'Descrição do projeto Sete',
      lotes: [
        LoteResponseModelMock.getMockLote4(),
        LoteResponseModelMock.getMockLote2(),
        LoteResponseModelMock.getMockLote1(),
      ],
    );
  }
}
