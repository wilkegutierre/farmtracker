import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/local/repositories/wallet_local_repository.dart';
import 'package:farmtracker/databases/models/response/wallet_response_model.dart';
import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:farmtracker/domains/repositories/wallet/wallet_repository.dart';
import 'package:farmtracker/views/cubits/wallet/wallet_cubit.dart';
import 'package:farmtracker/views/cubits/wallet/wallet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockWalletRepository extends Mock implements WalletRepository {}

class _MockWalletLocalRepository extends Mock implements WalletLocalRepository {}

class _FakeWalletModel extends Fake implements WalletModel {}

void main() {
  late _MockWalletRepository mockRemoteRepository;
  late _MockWalletLocalRepository mockLocalRepository;

  final walletFixture = WalletModel(id: 'wallet-001', name: 'Carteira Principal');

  final walletResponseFixture = WalletResponseModel(
    id: 'wallet-001',
    name: 'Carteira Principal',
    description: 'Carteira de clientes da região sul',
  );

  setUpAll(() {
    registerFallbackValue(_FakeWalletModel());
  });

  setUp(() {
    mockRemoteRepository = _MockWalletRepository();
    mockLocalRepository = _MockWalletLocalRepository();
  });

  WalletCubit buildCubit() => WalletCubit(mockRemoteRepository, mockLocalRepository);

  group('WalletCubit', () {
    test('estado inicial é WalletInitial', () {
      expect(buildCubit().state, const WalletInitial());
    });

    blocTest<WalletCubit, WalletState>(
      'syncWallets emite [WalletLoading, WalletListLoaded] e grava wallets localmente quando há dados',
      setUp: () {
        when(
          () => mockRemoteRepository.getWalletsByUserId('user-001'),
        ).thenAnswer((_) async => Success([walletResponseFixture]));
        when(
          () => mockLocalRepository.obterPorId('wallet-001'),
        ).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncWallets('user-001'),
      expect: () => [
        const WalletLoading(),
        WalletListLoaded([walletFixture]),
      ],
      verify: (_) {
        verify(() => mockLocalRepository.gravar(walletFixture)).called(1);
      },
    );

    blocTest<WalletCubit, WalletState>(
      'syncWallets atualiza wallet local quando registro já existe',
      setUp: () {
        when(
          () => mockRemoteRepository.getWalletsByUserId('user-001'),
        ).thenAnswer((_) async => Success([walletResponseFixture]));
        when(() => mockLocalRepository.obterPorId('wallet-001')).thenAnswer((_) async => Success(walletFixture));
        when(() => mockLocalRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncWallets('user-001'),
      expect: () => [
        const WalletLoading(),
        WalletListLoaded([walletFixture]),
      ],
      verify: (_) {
        verify(() => mockLocalRepository.alterar(walletFixture)).called(1);
        verifyNever(() => mockLocalRepository.gravar(any()));
      },
    );

    blocTest<WalletCubit, WalletState>(
      'syncWallets emite [WalletLoading, WalletListLoaded] quando lista remota está vazia',
      setUp: () {
        when(() => mockRemoteRepository.getWalletsByUserId('user-001')).thenAnswer((_) async => const Success([]));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncWallets('user-001'),
      expect: () => [const WalletLoading(), const WalletListLoaded([])],
      verify: (_) {
        verifyNever(() => mockLocalRepository.gravar(any()));
        verifyNever(() => mockLocalRepository.alterar(any()));
      },
    );

    blocTest<WalletCubit, WalletState>(
      'syncWallets emite [WalletLoading, WalletErro] quando repositório remoto falha',
      setUp: () {
        when(
          () => mockRemoteRepository.getWalletsByUserId(any()),
        ).thenAnswer((_) async => Failure(InternalServerError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncWallets('user-001'),
      expect: () => [const WalletLoading(), const WalletErro('Falha ao carregar wallets do usuário.')],
    );

    blocTest<WalletCubit, WalletState>(
      'syncWallets emite [WalletLoading, WalletErro] quando gravação local falha',
      setUp: () {
        when(
          () => mockRemoteRepository.getWalletsByUserId('user-001'),
        ).thenAnswer((_) async => Success([walletResponseFixture]));
        when(
          () => mockLocalRepository.obterPorId('wallet-001'),
        ).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => Failure(InsertDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncWallets('user-001'),
      expect: () => [const WalletLoading(), const WalletErro('Falha ao gravar wallets localmente.')],
    );

    blocTest<WalletCubit, WalletState>(
      'carregarWallets emite [WalletLoading, WalletListLoaded] quando há dados',
      setUp: () {
        when(() => mockLocalRepository.wallets()).thenAnswer((_) async => Success([walletFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarWallets(),
      expect: () => [
        const WalletLoading(),
        WalletListLoaded([walletFixture]),
      ],
    );

    blocTest<WalletCubit, WalletState>(
      'carregarWallets emite [WalletLoading, WalletErro] quando repositório falha',
      setUp: () {
        when(() => mockLocalRepository.wallets()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarWallets(),
      expect: () => [const WalletLoading(), const WalletErro('Falha ao carregar wallets.')],
    );

    blocTest<WalletCubit, WalletState>(
      'obterPorOwner emite [WalletLoading, WalletListLoaded] quando encontra wallets',
      setUp: () {
        when(() => mockLocalRepository.obterPorOwner('user-001')).thenAnswer((_) async => Success([walletFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorOwner('user-001'),
      expect: () => [
        const WalletLoading(),
        WalletListLoaded([walletFixture]),
      ],
    );

    blocTest<WalletCubit, WalletState>(
      'obterPorId emite [WalletLoading, WalletLoaded] quando wallet existe',
      setUp: () {
        when(() => mockLocalRepository.obterPorId('wallet-001')).thenAnswer((_) async => Success(walletFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('wallet-001'),
      expect: () => [const WalletLoading(), WalletLoaded(walletFixture)],
    );

    blocTest<WalletCubit, WalletState>(
      'obterPorId emite [WalletLoading, WalletErro] quando wallet não existe',
      setUp: () {
        when(() => mockLocalRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('wallet-999'),
      expect: () => [const WalletLoading(), const WalletErro('Wallet não encontrada.')],
    );

    blocTest<WalletCubit, WalletState>(
      'gravar emite [WalletLoading, WalletGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(walletFixture),
      expect: () => [const WalletLoading(), const WalletGravadoSucesso()],
    );

    blocTest<WalletCubit, WalletState>(
      'alterar emite [WalletLoading, WalletAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockLocalRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(walletFixture),
      expect: () => [const WalletLoading(), const WalletAlteradoSucesso()],
    );
  });
}
