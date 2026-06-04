import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/organization_local_repository.dart';
import 'package:farmtracker/databases/models/response/organization_response_model.dart';
import 'package:farmtracker/views/viewmodels/organization/organization_cubit.dart';
import 'package:farmtracker/views/viewmodels/organization/organization_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockOrganizationLocalRepository extends Mock implements OrganizationLocalRepository {}

class _FakeOrganizationResponseModel extends Fake implements OrganizationResponseModel {}

void main() {
  late _MockOrganizationLocalRepository mockRepository;

  final organizationFixture = OrganizationResponseModel(
    id: 'org-001',
    description: 'Organização Agrícola Sul',
    addressId: 'address-001',
  );

  setUpAll(() {
    registerFallbackValue(_FakeOrganizationResponseModel());
  });

  setUp(() {
    mockRepository = _MockOrganizationLocalRepository();
  });

  OrganizationCubit buildCubit() => OrganizationCubit(mockRepository);

  group('OrganizationCubit', () {
    test('estado inicial é OrganizationInitial', () {
      expect(buildCubit().state, const OrganizationInitial());
    });

    blocTest<OrganizationCubit, OrganizationState>(
      'carregarOrganizations emite [OrganizationLoading, OrganizationListLoaded] quando há dados',
      setUp: () {
        when(() => mockRepository.organizations()).thenAnswer((_) async => Success([organizationFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarOrganizations(),
      expect: () => [
        const OrganizationLoading(),
        OrganizationListLoaded([organizationFixture]),
      ],
    );

    blocTest<OrganizationCubit, OrganizationState>(
      'carregarOrganizations emite [OrganizationLoading, OrganizationErro] quando repositório falha',
      setUp: () {
        when(() => mockRepository.organizations()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarOrganizations(),
      expect: () => [
        const OrganizationLoading(),
        const OrganizationErro('Falha ao carregar organizations.'),
      ],
    );

    blocTest<OrganizationCubit, OrganizationState>(
      'obterPorAddressId emite [OrganizationLoading, OrganizationListLoaded] quando encontra organizations',
      setUp: () {
        when(() => mockRepository.obterPorAddressId('address-001')).thenAnswer((_) async => Success([organizationFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorAddressId('address-001'),
      expect: () => [
        const OrganizationLoading(),
        OrganizationListLoaded([organizationFixture]),
      ],
    );

    blocTest<OrganizationCubit, OrganizationState>(
      'obterPorId emite [OrganizationLoading, OrganizationLoaded] quando organization existe',
      setUp: () {
        when(() => mockRepository.obterPorId('org-001')).thenAnswer((_) async => Success(organizationFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('org-001'),
      expect: () => [
        const OrganizationLoading(),
        OrganizationLoaded(organizationFixture),
      ],
    );

    blocTest<OrganizationCubit, OrganizationState>(
      'obterPorId emite [OrganizationLoading, OrganizationErro] quando organization não existe',
      setUp: () {
        when(() => mockRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('org-999'),
      expect: () => [
        const OrganizationLoading(),
        const OrganizationErro('Organization não encontrada.'),
      ],
    );

    blocTest<OrganizationCubit, OrganizationState>(
      'gravar emite [OrganizationLoading, OrganizationGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(organizationFixture),
      expect: () => [
        const OrganizationLoading(),
        const OrganizationGravadoSucesso(),
      ],
    );

    blocTest<OrganizationCubit, OrganizationState>(
      'alterar emite [OrganizationLoading, OrganizationAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(organizationFixture),
      expect: () => [
        const OrganizationLoading(),
        const OrganizationAlteradoSucesso(),
      ],
    );
  });
}
