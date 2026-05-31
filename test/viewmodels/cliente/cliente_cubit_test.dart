import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/local/repositories/cliente_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cliente_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/endereco_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/lote_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/lote_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/projeto_local_repository.dart';
import 'package:farmtracker/domains/models/cliente_cultura_model.dart';
import 'package:farmtracker/domains/models/cliente_model.dart';
import 'package:farmtracker/domains/models/cultura_model.dart';
import 'package:farmtracker/domains/models/endereco_model.dart';
import 'package:farmtracker/domains/repositories/cliente/cliente_repository.dart';
import 'package:farmtracker/domains/repositories/cultura/cultura_repository.dart';
import 'package:farmtracker/domains/repositories/endereco/endereco_repository.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_cubit.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────

class _MockClienteRepository extends Mock implements ClienteRepository {}

class _MockClienteLocalRepository extends Mock implements ClienteLocalRepository {}

class _MockCulturaRepository extends Mock implements CulturaRepository {}

class _MockCulturaLocalRepository extends Mock implements CulturaLocalRepository {}

class _MockClienteCulturaLocalRepository extends Mock implements ClienteCulturaLocalRepository {}

class _MockEnderecoLocalRepository extends Mock implements EnderecoLocalRepository {}

class _MockEnderecoRepository extends Mock implements EnderecoRepository {}

class _MockProjetoLocalRepository extends Mock implements ProjetoLocalRepository {}

class _MockLoteLocalRepository extends Mock implements LoteLocalRepository {}

class _MockLoteCulturaLocalRepository extends Mock implements LoteCulturaLocalRepository {}

// ── Fakes para registerFallbackValue ──────────────────────────────────────

class _FakeClienteModel extends Fake implements ClienteModel {}

class _FakeClienteCulturaModel extends Fake implements ClienteCulturaModel {}

class _FakeEnderecoModel extends Fake implements EnderecoModel {}

// ── Fixtures ──────────────────────────────────────────────────────────────

final _clienteFixture = ClienteModel(
  uuid: 'uuid-cliente-01',
  nome: 'Fazenda Boa Vista',
  email: 'fazenda@test.com',
  celular: '11999990000',
  observacao: '',
  proprietario: 'João Silva',
  responsavelTecnico: 'Dr. Pedro',
);

final _enderecoFixture = EnderecoModel(
  uuid: 'uuid-end-01',
  logradouro: 'Estrada Rural',
  bairro: 'Zona Rural',
  cidade: 'Ribeirão Preto',
  uf: 'SP',
  cep: '14000000',
  numero: 1,
  complemento: '',
  principal: 1,
  pessoa: _clienteFixture.uuid,
);

void main() {
  late _MockClienteRepository mockClienteRepo;
  late _MockClienteLocalRepository mockClienteLocalRepo;
  late _MockCulturaRepository mockCulturaRepo;
  late _MockCulturaLocalRepository mockCulturaLocalRepo;
  late _MockClienteCulturaLocalRepository mockClienteCulturaLocalRepo;
  late _MockEnderecoLocalRepository mockEnderecoLocalRepo;
  late _MockEnderecoRepository mockEnderecoRepo;
  late _MockProjetoLocalRepository mockProjetoLocalRepo;
  late _MockLoteLocalRepository mockLoteLocalRepo;
  late _MockLoteCulturaLocalRepository mockLoteCulturaLocalRepo;

  setUpAll(() {
    registerFallbackValue(_FakeClienteModel());
    registerFallbackValue(_FakeClienteCulturaModel());
    registerFallbackValue(_FakeEnderecoModel());
  });

  setUp(() {
    mockClienteRepo = _MockClienteRepository();
    mockClienteLocalRepo = _MockClienteLocalRepository();
    mockCulturaRepo = _MockCulturaRepository();
    mockCulturaLocalRepo = _MockCulturaLocalRepository();
    mockClienteCulturaLocalRepo = _MockClienteCulturaLocalRepository();
    mockEnderecoLocalRepo = _MockEnderecoLocalRepository();
    mockEnderecoRepo = _MockEnderecoRepository();
    mockProjetoLocalRepo = _MockProjetoLocalRepository();
    mockLoteLocalRepo = _MockLoteLocalRepository();
    mockLoteCulturaLocalRepo = _MockLoteCulturaLocalRepository();
  });

  ClienteCubit buildCubit() => ClienteCubit(
    mockClienteRepo,
    mockCulturaRepo,
    mockCulturaLocalRepo,
    mockClienteCulturaLocalRepo,
    mockClienteLocalRepo,
    mockEnderecoLocalRepo,
    mockEnderecoRepo,
    mockProjetoLocalRepo,
    mockLoteLocalRepo,
    mockLoteCulturaLocalRepo,
  );

  group('ClienteCubit —', () {
    test('estado inicial é ClienteInitial', () {
      expect(buildCubit().state, const ClienteInitial());
    });

    // ───────────── sincronizarClientesSeNecessario ─────────────

    group('sincronizarClientesSeNecessario()', () {
      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteLoading, ClienteSincronizado] quando já está sincronizado',
        setUp: () {
          when(() => mockClienteLocalRepo.hasSyncNearDate(any())).thenAnswer((_) async => const Success(true));
        },
        build: buildCubit,
        act: (cubit) => cubit.sincronizarClientesSeNecessario(DateTime.now()),
        expect: () => [const ClienteLoading(), const ClienteSincronizado()],
        verify: (_) {
          verify(() => mockClienteLocalRepo.hasSyncNearDate(any())).called(1);
          verifyNever(() => mockClienteRepo.syncClients(any()));
        },
      );

      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteLoading, ClienteErro] quando sincronização falha',
        setUp: () {
          when(() => mockClienteLocalRepo.hasSyncNearDate(any())).thenAnswer((_) async => const Success(false));
          when(() => mockClienteRepo.syncClients(any())).thenAnswer((_) async => Failure(Exception('Erro de rede')));
        },
        build: buildCubit,
        act: (cubit) => cubit.sincronizarClientesSeNecessario(DateTime.now()),
        expect: () => [const ClienteLoading(), isA<ClienteErro>()],
      );
    });

    // ───────────── obterRelacaoClientes ─────────────

    group('obterRelacaoClientes()', () {
      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteLoading, ClienteRelacaoCarregada] com clientes e endereços',
        setUp: () {
          when(() => mockClienteLocalRepo.getClientes()).thenAnswer((_) async => Success([_clienteFixture]));
          when(() => mockEnderecoLocalRepo.obterPorCliente(any())).thenAnswer((_) async => Success([_enderecoFixture]));
        },
        build: buildCubit,
        act: (cubit) => cubit.obterRelacaoClientes(),
        expect: () => [const ClienteLoading(), isA<ClienteRelacaoCarregada>()],
        verify: (cubit) {
          final state = cubit.state as ClienteRelacaoCarregada;
          expect(state.clientes, hasLength(1));
          expect(state.clientes.first.enderecos, isNotNull);
          expect(state.clientes.first.enderecos!.first.cidade, 'Ribeirão Preto');
        },
      );

      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteLoading, ClienteRelacaoCarregada] com lista vazia quando sem clientes',
        setUp: () {
          when(() => mockClienteLocalRepo.getClientes()).thenAnswer((_) async => const Success([]));
        },
        build: buildCubit,
        act: (cubit) => cubit.obterRelacaoClientes(),
        expect: () => [const ClienteLoading(), const ClienteRelacaoCarregada([])],
      );

      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteLoading, ClienteErro] quando repositório falha',
        setUp: () {
          when(() => mockClienteLocalRepo.getClientes()).thenAnswer((_) async => Failure(Exception('DB error')));
        },
        build: buildCubit,
        act: (cubit) => cubit.obterRelacaoClientes(),
        expect: () => [const ClienteLoading(), isA<ClienteErro>()],
      );
    });

    // ───────────── gravarCliente ─────────────

    group('gravarCliente()', () {
      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteGravadoSucesso] quando novo cliente é gravado com sucesso',
        setUp: () {
          when(() => mockClienteLocalRepo.gravar(any())).thenAnswer((_) async => const Success(true));
        },
        build: buildCubit,
        act: (cubit) => cubit.gravarCliente(_clienteFixture, novoCliente: true),
        expect: () => [isA<ClienteGravadoSucesso>()],
        verify: (_) {
          verify(() => mockClienteLocalRepo.gravar(any())).called(1);
        },
      );

      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteErro] quando gravação de novo cliente falha',
        setUp: () {
          when(() => mockClienteLocalRepo.gravar(any())).thenAnswer((_) async => Failure(Exception('DB write error')));
        },
        build: buildCubit,
        act: (cubit) => cubit.gravarCliente(_clienteFixture, novoCliente: true),
        expect: () => [isA<ClienteErro>()],
      );

      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteGravadoSucesso] quando cliente existente é atualizado',
        setUp: () {
          when(() => mockClienteLocalRepo.atualizar(any())).thenAnswer((_) async => const Success(true));
        },
        build: buildCubit,
        act: (cubit) => cubit.gravarCliente(_clienteFixture),
        expect: () => [isA<ClienteGravadoSucesso>()],
        verify: (_) {
          verify(() => mockClienteLocalRepo.atualizar(any())).called(1);
          verifyNever(() => mockClienteLocalRepo.gravar(any()));
        },
      );
    });

    // ───────────── atualizarFluxo ─────────────

    group('atualizarFluxo()', () {
      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteFluxoAtualizado] com fluxo lote e nome do projeto',
        build: buildCubit,
        act: (cubit) => cubit.atualizarFluxo(ProjectoStateFlow.lote, projeto: 'Plantio de Milho'),
        expect: () => [const ClienteFluxoAtualizado(fluxo: ProjectoStateFlow.lote, projeto: 'Plantio de Milho')],
      );

      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteFluxoAtualizado] com fluxo projeto ao inicializar',
        build: buildCubit,
        act: (cubit) => cubit.inicializarFluxo(),
        expect: () => [const ClienteFluxoAtualizado(fluxo: ProjectoStateFlow.projeto)],
      );
    });

    // ───────────── relacionarClienteCultura ─────────────

    group('relacionarClienteCultura()', () {
      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteCulturaRelacionada] com a relação correta',
        build: buildCubit,
        act: (cubit) {
          final clienteCultura = ClienteCulturaModel(
            cliente: 'uuid-cliente-01',
            cultura: 'uuid-cultura-01',
            area: 12.5,
            projeto: 'uuid-projeto-01',
            lote: 'uuid-lote-01',
          );
          final cultura = CulturaModel(
            uuid: 'uuid-cultura-01',
            nome: 'Milho',
            descricao: 'Cultura de milho verão',
            urlImagem: '',
          );
          cubit.relacionarClienteCultura(clienteCultura, cultura);
        },
        expect: () => [isA<ClienteCulturaRelacionada>()],
        verify: (cubit) {
          final state = cubit.state as ClienteCulturaRelacionada;
          expect(state.relacoes, hasLength(1));
          expect(state.relacoes.first.nomeCultura, 'Milho');
          expect(state.relacoes.first.areaCultura, 12.5);
        },
      );
    });

    // ───────────── obterClienteCulturas ─────────────

    group('obterClienteCulturas()', () {
      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteCulturasCarregadas] com as culturas do cliente',
        setUp: () {
          final cultura = ClienteCulturaModel(
            cliente: 'uuid-cliente-01',
            cultura: 'uuid-cultura-01',
            area: 8.0,
            projeto: 'uuid-projeto-01',
            lote: 'uuid-lote-01',
          );
          when(
            () => mockClienteCulturaLocalRepo.obterCulturasPorCliente(any()),
          ).thenAnswer((_) async => Success([cultura]));
        },
        build: buildCubit,
        act: (cubit) => cubit.obterClienteCulturas(cliente: 'uuid-cliente-01'),
        expect: () => [isA<ClienteCulturasCarregadas>()],
        verify: (cubit) {
          final state = cubit.state as ClienteCulturasCarregadas;
          expect(state.culturas, hasLength(1));
        },
      );

      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteCulturasCarregadas] com lista vazia quando falha',
        setUp: () {
          when(
            () => mockClienteCulturaLocalRepo.obterCulturasPorCliente(any()),
          ).thenAnswer((_) async => Failure(Exception('not found')));
        },
        build: buildCubit,
        act: (cubit) => cubit.obterClienteCulturas(cliente: 'uuid-cliente-01'),
        expect: () => [const ClienteCulturasCarregadas([])],
      );
    });

    // ───────────── limparDadosMemoria ─────────────

    group('limparDadosMemoria()', () {
      blocTest<ClienteCubit, ClienteState>(
        'emite [ClienteInitial] ao limpar os dados',
        build: buildCubit,
        seed: () => ClienteRelacaoCarregada([_clienteFixture]),
        act: (cubit) => cubit.limparDadosMemoria(),
        expect: () => [const ClienteInitial()],
      );
    });

    // ───────────── criarIdentificadorCliente ─────────────

    test('criarIdentificadorCliente() retorna UUID v4 válido', () {
      final uuid = buildCubit().criarIdentificadorCliente();
      final uuidRegex = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: false,
      );
      expect(uuidRegex.hasMatch(uuid), isTrue);
    });
  });
}
