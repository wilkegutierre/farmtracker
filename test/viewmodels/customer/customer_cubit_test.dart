import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/local/repositories/customer_local_repository.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:farmtracker/domains/repositories/customer/customer_repository.dart';
import 'package:farmtracker/views/cubits/customer/customer_cubit.dart';
import 'package:farmtracker/views/cubits/customer/customer_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockCustomerRepository extends Mock implements CustomerRepository {}

class _MockCustomerLocalRepository extends Mock implements CustomerLocalRepository {}

class _FakeCustomerResponseModel extends Fake implements CustomerResponseModel {}

void main() {
  late _MockCustomerRepository mockRemoteRepository;
  late _MockCustomerLocalRepository mockLocalRepository;

  final customerFixture = CustomerResponseModel(
    id: 'customer-001',
    proprietario: 'João Silva',
    responsavelTecnico: 'Dr. Pedro',
    email: 'fazenda@test.com',
    orgOwner: 'org-001',
  );

  final walletFixture = WalletModel(id: 'wallet-001', name: 'Carteira Principal');

  setUpAll(() {
    registerFallbackValue(_FakeCustomerResponseModel());
  });

  setUp(() {
    mockRemoteRepository = _MockCustomerRepository();
    mockLocalRepository = _MockCustomerLocalRepository();
  });

  CustomerCubit buildCubit() => CustomerCubit(mockRemoteRepository, mockLocalRepository);

  group('CustomerCubit', () {
    test('estado inicial é CustomerInitial', () {
      expect(buildCubit().state, const CustomerInitial());
    });

    blocTest<CustomerCubit, CustomerState>(
      'syncCustomersByWallet emite [CustomerLoading, CustomerListLoaded] e grava customers localmente quando há dados',
      setUp: () {
        when(
          () => mockRemoteRepository.getCustomersByWalletId('wallet-001'),
        ).thenAnswer((_) async => Success([customerFixture]));
        when(
          () => mockLocalRepository.obterPorId('customer-001'),
        ).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncCustomersByWallet([walletFixture]),
      expect: () => [
        const CustomerLoading(),
        CustomerListLoaded([customerFixture]),
      ],
      verify: (_) {
        verify(() => mockLocalRepository.gravar(customerFixture)).called(1);
      },
    );

    blocTest<CustomerCubit, CustomerState>(
      'syncCustomersByWallet atualiza customer local quando registro já existe',
      setUp: () {
        when(
          () => mockRemoteRepository.getCustomersByWalletId('wallet-001'),
        ).thenAnswer((_) async => Success([customerFixture]));
        when(() => mockLocalRepository.obterPorId('customer-001')).thenAnswer((_) async => Success(customerFixture));
        when(() => mockLocalRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncCustomersByWallet([walletFixture]),
      expect: () => [
        const CustomerLoading(),
        CustomerListLoaded([customerFixture]),
      ],
      verify: (_) {
        verify(() => mockLocalRepository.alterar(customerFixture)).called(1);
        verifyNever(() => mockLocalRepository.gravar(any()));
      },
    );

    blocTest<CustomerCubit, CustomerState>(
      'syncCustomersByWallet emite [CustomerLoading, CustomerListLoaded] quando lista remota está vazia',
      setUp: () {
        when(
          () => mockRemoteRepository.getCustomersByWalletId('wallet-001'),
        ).thenAnswer((_) async => const Success([]));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncCustomersByWallet([walletFixture]),
      expect: () => [const CustomerLoading(), const CustomerListLoaded([])],
      verify: (_) {
        verifyNever(() => mockLocalRepository.gravar(any()));
        verifyNever(() => mockLocalRepository.alterar(any()));
      },
    );

    blocTest<CustomerCubit, CustomerState>(
      'syncCustomersByWallet emite [CustomerLoading, CustomerErro] quando repositório remoto falha',
      setUp: () {
        when(
          () => mockRemoteRepository.getCustomersByWalletId(any()),
        ).thenAnswer((_) async => Failure(InternalServerError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncCustomersByWallet([walletFixture]),
      expect: () => [const CustomerLoading(), const CustomerErro('Falha ao carregar customers da carteira.')],
    );

    blocTest<CustomerCubit, CustomerState>(
      'syncCustomersByWallet emite [CustomerLoading, CustomerErro] quando gravação local falha',
      setUp: () {
        when(
          () => mockRemoteRepository.getCustomersByWalletId('wallet-001'),
        ).thenAnswer((_) async => Success([customerFixture]));
        when(
          () => mockLocalRepository.obterPorId('customer-001'),
        ).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => Failure(InsertDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncCustomersByWallet([walletFixture]),
      expect: () => [const CustomerLoading(), const CustomerErro('Falha ao gravar customers localmente.')],
    );

    blocTest<CustomerCubit, CustomerState>(
      'carregarCustomers emite [CustomerLoading, CustomerListLoaded] quando há dados',
      setUp: () {
        when(() => mockLocalRepository.customers()).thenAnswer((_) async => Success([customerFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarCustomers(),
      expect: () => [
        const CustomerLoading(),
        CustomerListLoaded([customerFixture]),
      ],
    );

    blocTest<CustomerCubit, CustomerState>(
      'carregarCustomers emite [CustomerLoading, CustomerErro] quando repositório falha',
      setUp: () {
        when(() => mockLocalRepository.customers()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarCustomers(),
      expect: () => [const CustomerLoading(), const CustomerErro('Falha ao carregar customers.')],
    );

    blocTest<CustomerCubit, CustomerState>(
      'obterPorOrgOwner emite [CustomerLoading, CustomerListLoaded] quando encontra customers',
      setUp: () {
        when(() => mockLocalRepository.obterPorOrgOwner('org-001')).thenAnswer((_) async => Success([customerFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorOrgOwner('org-001'),
      expect: () => [
        const CustomerLoading(),
        CustomerListLoaded([customerFixture]),
      ],
    );

    blocTest<CustomerCubit, CustomerState>(
      'obterPorId emite [CustomerLoading, CustomerLoaded] quando customer existe',
      setUp: () {
        when(() => mockLocalRepository.obterPorId('customer-001')).thenAnswer((_) async => Success(customerFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('customer-001'),
      expect: () => [const CustomerLoading(), CustomerLoaded(customerFixture)],
    );

    blocTest<CustomerCubit, CustomerState>(
      'obterPorId emite [CustomerLoading, CustomerErro] quando customer não existe',
      setUp: () {
        when(() => mockLocalRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('customer-999'),
      expect: () => [const CustomerLoading(), const CustomerErro('Customer não encontrado.')],
    );

    blocTest<CustomerCubit, CustomerState>(
      'gravar emite [CustomerLoading, CustomerGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(customerFixture),
      expect: () => [const CustomerLoading(), const CustomerGravadoSucesso()],
    );

    blocTest<CustomerCubit, CustomerState>(
      'alterar emite [CustomerLoading, CustomerAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockLocalRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(customerFixture),
      expect: () => [const CustomerLoading(), const CustomerAlteradoSucesso()],
    );
  });
}
