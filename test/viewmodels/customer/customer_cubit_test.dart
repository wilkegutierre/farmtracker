import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/customer_local_repository.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/views/viewmodels/customer/customer_cubit.dart';
import 'package:farmtracker/views/viewmodels/customer/customer_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockCustomerLocalRepository extends Mock implements CustomerLocalRepository {}

class _FakeCustomerResponseModel extends Fake implements CustomerResponseModel {}

void main() {
  late _MockCustomerLocalRepository mockRepository;

  final customerFixture = CustomerResponseModel(
    id: 'customer-001',
    proprietario: 'João Silva',
    responsavelTechnico: 'Dr. Pedro',
    email: 'fazenda@test.com',
    orgOwner: 'org-001',
  );

  setUpAll(() {
    registerFallbackValue(_FakeCustomerResponseModel());
  });

  setUp(() {
    mockRepository = _MockCustomerLocalRepository();
  });

  CustomerCubit buildCubit() => CustomerCubit(mockRepository);

  group('CustomerCubit', () {
    test('estado inicial é CustomerInitial', () {
      expect(buildCubit().state, const CustomerInitial());
    });

    blocTest<CustomerCubit, CustomerState>(
      'carregarCustomers emite [CustomerLoading, CustomerListLoaded] quando há dados',
      setUp: () {
        when(() => mockRepository.customers()).thenAnswer((_) async => Success([customerFixture]));
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
        when(() => mockRepository.customers()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarCustomers(),
      expect: () => [const CustomerLoading(), const CustomerErro('Falha ao carregar customers.')],
    );

    blocTest<CustomerCubit, CustomerState>(
      'obterPorOrgOwner emite [CustomerLoading, CustomerListLoaded] quando encontra customers',
      setUp: () {
        when(() => mockRepository.obterPorOrgOwner('org-001')).thenAnswer((_) async => Success([customerFixture]));
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
        when(() => mockRepository.obterPorId('customer-001')).thenAnswer((_) async => Success(customerFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('customer-001'),
      expect: () => [const CustomerLoading(), CustomerLoaded(customerFixture)],
    );

    blocTest<CustomerCubit, CustomerState>(
      'obterPorId emite [CustomerLoading, CustomerErro] quando customer não existe',
      setUp: () {
        when(() => mockRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('customer-999'),
      expect: () => [const CustomerLoading(), const CustomerErro('Customer não encontrado.')],
    );

    blocTest<CustomerCubit, CustomerState>(
      'gravar emite [CustomerLoading, CustomerGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(customerFixture),
      expect: () => [const CustomerLoading(), const CustomerGravadoSucesso()],
    );

    blocTest<CustomerCubit, CustomerState>(
      'alterar emite [CustomerLoading, CustomerAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(customerFixture),
      expect: () => [const CustomerLoading(), const CustomerAlteradoSucesso()],
    );
  });
}
