import 'package:farmtracker/databases/models/response/endereco_response_model.dart';

EnderecoResponseModel getMockEndereco() => EnderecoResponseModel(
      uuid: '456abcde-f123-12d3-a456-426614174000',
      logradouro: 'Av. Brigadeiro Faria Lima',
      numero: 3600,
      complemento: 'Apto 1',
      bairro: 'Itaim Bibi',
      cidade: 'São Paulo',
      uf: 'SP',
      cep: '04538-132',
      principal: true,
      pessoa: '987fcdeb-51a3-12d3-a456-426614174000',
    );

EnderecoResponseModel getMockEndereco1() => EnderecoResponseModel(
      uuid: '456abcde-f123-12d3-a456-426614174001',
      logradouro: 'Avenida Paulista',
      numero: 1500,
      complemento: 'Sala 1205',
      bairro: 'Bela Vista',
      cidade: 'São Paulo',
      uf: 'SP',
      cep: '01310-200',
      principal: true,
      pessoa: '987fcdeb-51a3-12d3-a456-426614174001',
    );

EnderecoResponseModel getMockEndereco2() => EnderecoResponseModel(
      uuid: '456abcde-f123-12d3-a456-426614174002',
      logradouro: 'Rua das Flores',
      numero: 250,
      complemento: 'Casa',
      bairro: 'Centro',
      cidade: 'Curitiba',
      uf: 'PR',
      cep: '80010-140',
      principal: true,
      pessoa: '987fcdeb-51a3-12d3-a456-426614174002',
    );

EnderecoResponseModel getMockEndereco3() => EnderecoResponseModel(
      uuid: '456abcde-f123-12d3-a456-426614174003',
      logradouro: 'Rua Copacabana',
      numero: 1000,
      complemento: 'Bloco B Apto 502',
      bairro: 'Copacabana',
      cidade: 'Rio de Janeiro',
      uf: 'RJ',
      cep: '22050-002',
      principal: true,
      pessoa: '987fcdeb-51a3-12d3-a456-426614174003',
    );

EnderecoResponseModel getMockEndereco4() => EnderecoResponseModel(
      uuid: '456abcde-f123-12d3-a456-426614174004',
      logradouro: 'Avenida Getúlio Vargas',
      numero: 450,
      complemento: 'Loja 12',
      bairro: 'Funcionários',
      cidade: 'Belo Horizonte',
      uf: 'MG',
      cep: '30112-020',
      principal: true,
      pessoa: '987fcdeb-51a3-12d3-a456-426614174004',
    );
EnderecoResponseModel getMockEndereco5() => EnderecoResponseModel(
      uuid: '456abcde-f123-12d3-a456-426614174005',
      logradouro: 'Rua dos Andradas',
      numero: 1234,
      complemento: 'Conjunto 301',
      bairro: 'Centro Histórico',
      cidade: 'Porto Alegre',
      uf: 'RS',
      cep: '90020-008',
      principal: false,
      pessoa: '987fcdeb-51a3-12d3-a456-426614174004',
    );

List<EnderecoResponseModel> getMockEnderecos() => [
      getMockEndereco(),
      getMockEndereco1(),
      getMockEndereco2(),
      getMockEndereco3(),
      getMockEndereco4(),
      getMockEndereco5(),
    ];
