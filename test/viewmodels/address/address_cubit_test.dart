import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/address_local_repository.dart';
import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:farmtracker/views/viewmodels/address/address_cubit.dart';
import 'package:farmtracker/views/viewmodels/address/address_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockAddressLocalRepository extends Mock implements AddressLocalRepository {}

class _FakeAddressResponseModel extends Fake implements AddressResponseModel {}

void main() {
  late _MockAddressLocalRepository mockRepository;

  final addressFixture = AddressResponseModel(
    id: 'address-001',
    orgOwner: 'org-001',
    owner: 'customer-001',
    street: 'Rua das Flores',
    city: 'Ribeirão Preto',
    uf: 'SP',
  );

  setUpAll(() {
    registerFallbackValue(_FakeAddressResponseModel());
  });

  setUp(() {
    mockRepository = _MockAddressLocalRepository();
  });

  AddressCubit buildCubit() => AddressCubit(mockRepository);

  group('AddressCubit', () {
    test('estado inicial é AddressInitial', () {
      expect(buildCubit().state, const AddressInitial());
    });

    blocTest<AddressCubit, AddressState>(
      'carregarAddresses emite [AddressLoading, AddressListLoaded] quando há dados',
      setUp: () {
        when(() => mockRepository.addresses()).thenAnswer((_) async => Success([addressFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarAddresses(),
      expect: () => [
        const AddressLoading(),
        AddressListLoaded([addressFixture]),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'carregarAddresses emite [AddressLoading, AddressErro] quando repositório falha',
      setUp: () {
        when(() => mockRepository.addresses()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarAddresses(),
      expect: () => [
        const AddressLoading(),
        const AddressErro('Falha ao carregar addresses.'),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'obterPorOwner emite [AddressLoading, AddressListLoaded] quando encontra addresses',
      setUp: () {
        when(() => mockRepository.obterPorOwner('customer-001')).thenAnswer((_) async => Success([addressFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorOwner('customer-001'),
      expect: () => [
        const AddressLoading(),
        AddressListLoaded([addressFixture]),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'obterPorOrgOwner emite [AddressLoading, AddressListLoaded] quando encontra addresses',
      setUp: () {
        when(() => mockRepository.obterPorOrgOwner('org-001')).thenAnswer((_) async => Success([addressFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorOrgOwner('org-001'),
      expect: () => [
        const AddressLoading(),
        AddressListLoaded([addressFixture]),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'obterPorId emite [AddressLoading, AddressLoaded] quando address existe',
      setUp: () {
        when(() => mockRepository.obterPorId('address-001')).thenAnswer((_) async => Success(addressFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('address-001'),
      expect: () => [
        const AddressLoading(),
        AddressLoaded(addressFixture),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'obterPorId emite [AddressLoading, AddressErro] quando address não existe',
      setUp: () {
        when(() => mockRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('address-999'),
      expect: () => [
        const AddressLoading(),
        const AddressErro('Address não encontrado.'),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'gravar emite [AddressLoading, AddressGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(addressFixture),
      expect: () => [
        const AddressLoading(),
        const AddressGravadoSucesso(),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'alterar emite [AddressLoading, AddressAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(addressFixture),
      expect: () => [
        const AddressLoading(),
        const AddressAlteradoSucesso(),
      ],
    );
  });
}
