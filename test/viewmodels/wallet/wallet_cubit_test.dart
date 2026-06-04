import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/wallet_local_repository.dart';
import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:farmtracker/views/viewmodels/wallet/wallet_cubit.dart';
import 'package:farmtracker/views/viewmodels/wallet/wallet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockWalletLocalRepository extends Mock implements WalletLocalRepository {}

class _FakeWalletModel extends Fake implements WalletModel {}

void main() {
  late _MockWalletLocalRepository mockRepository;

  final walletFixture = WalletModel(
    id: 'wallet-001',
    name: 'Carteira Principal',
    description: 'Carteira de clientes da região sul',
    owner: 'user-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  setUpAll(() {
    registerFallbackValue(_FakeWalletModel());
  });

  setUp(() {
    mockRepository = _MockWalletLocalRepository();
  });

  WalletCubit buildCubit() => WalletCubit(mockRepository);

  group('WalletCubit', () {
    test('estado inicial é WalletInitial', () {
      expect(buildCubit().state, const WalletInitial());
    });

    blocTest<WalletCubit, WalletState>(
      'carregarWallets emite [WalletLoading, WalletListLoaded] quando há dados',
      setUp: () {
        when(() => mockRepository.wallets()).thenAnswer((_) async => Success([walletFixture]));
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
        when(() => mockRepository.wallets()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarWallets(),
      expect: () => [
        const WalletLoading(),
        const WalletErro('Falha ao carregar wallets.'),
      ],
    );

    blocTest<WalletCubit, WalletState>(
      'obterPorOwner emite [WalletLoading, WalletListLoaded] quando encontra wallets',
      setUp: () {
        when(() => mockRepository.obterPorOwner('user-001')).thenAnswer((_) async => Success([walletFixture]));
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
        when(() => mockRepository.obterPorId('wallet-001')).thenAnswer((_) async => Success(walletFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('wallet-001'),
      expect: () => [
        const WalletLoading(),
        WalletLoaded(walletFixture),
      ],
    );

    blocTest<WalletCubit, WalletState>(
      'obterPorId emite [WalletLoading, WalletErro] quando wallet não existe',
      setUp: () {
        when(() => mockRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('wallet-999'),
      expect: () => [
        const WalletLoading(),
        const WalletErro('Wallet não encontrada.'),
      ],
    );

    blocTest<WalletCubit, WalletState>(
      'gravar emite [WalletLoading, WalletGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(walletFixture),
      expect: () => [
        const WalletLoading(),
        const WalletGravadoSucesso(),
      ],
    );

    blocTest<WalletCubit, WalletState>(
      'alterar emite [WalletLoading, WalletAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(walletFixture),
      expect: () => [
        const WalletLoading(),
        const WalletAlteradoSucesso(),
      ],
    );
  });
}
