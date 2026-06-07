import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/local/repositories/base_entity_local_repository.dart';
import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/domains/repositories/base_entity/base_entity_repository.dart';
import 'package:farmtracker/views/cubits/base_entity/base_entity_cubit.dart';
import 'package:farmtracker/views/cubits/base_entity/base_entity_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockBaseEntityRepository extends Mock implements BaseEntityRepository {}

class _MockBaseEntityLocalRepository extends Mock implements BaseEntityLocalRepository {}

class _FakeBaseEntityResponseModel extends Fake implements BaseEntityResponseModel {}

void main() {
  late _MockBaseEntityRepository mockRemoteRepository;
  late _MockBaseEntityLocalRepository mockLocalRepository;

  final baseEntityFixture = BaseEntityResponseModel(
    id: 'entity-001',
    orgOwner: 'org-001',
    name: 'Fazenda Boa Vista',
    type: 'PJ',
    docNumber: '12345678000199',
  );

  final customerFixture = CustomerResponseModel(
    id: 'customer-001',
    entity: 'entity-001',
  );

  setUpAll(() {
    registerFallbackValue(_FakeBaseEntityResponseModel());
  });

  setUp(() {
    mockRemoteRepository = _MockBaseEntityRepository();
    mockLocalRepository = _MockBaseEntityLocalRepository();
  });

  BaseEntityCubit buildCubit() => BaseEntityCubit(mockRemoteRepository, mockLocalRepository);

  group('BaseEntityCubit', () {
    test('estado inicial é BaseEntityInitial', () {
      expect(buildCubit().state, const BaseEntityInitial());
    });

    blocTest<BaseEntityCubit, BaseEntityState>(
      'syncBaseEntitiesByCustomers emite [BaseEntityLoading, BaseEntityListLoaded] e grava localmente quando há dados',
      setUp: () {
        when(() => mockRemoteRepository.getByOwnerId('entity-001')).thenAnswer((_) async => Success([baseEntityFixture]));
        when(() => mockLocalRepository.obterPorId('entity-001')).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncBaseEntitiesByCustomers([customerFixture]),
      expect: () => [
        const BaseEntityLoading(),
        BaseEntityListLoaded([baseEntityFixture]),
      ],
      verify: (_) {
        verify(() => mockRemoteRepository.getByOwnerId('entity-001')).called(1);
        verify(() => mockLocalRepository.gravar(baseEntityFixture)).called(1);
      },
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'syncBaseEntitiesByCustomers emite [BaseEntityLoading, BaseEntityErro] quando repositório remoto falha',
      setUp: () {
        when(() => mockRemoteRepository.getByOwnerId(any())).thenAnswer((_) async => Failure(InternalServerError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncBaseEntitiesByCustomers([customerFixture]),
      expect: () => [const BaseEntityLoading(), const BaseEntityErro('Falha ao carregar base entities por customer.')],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'carregarBaseEntities emite [BaseEntityLoading, BaseEntityListLoaded] quando há dados',
      setUp: () {
        when(() => mockLocalRepository.baseEntities()).thenAnswer((_) async => Success([baseEntityFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarBaseEntities(),
      expect: () => [
        const BaseEntityLoading(),
        BaseEntityListLoaded([baseEntityFixture]),
      ],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'carregarBaseEntities emite [BaseEntityLoading, BaseEntityErro] quando repositório falha',
      setUp: () {
        when(() => mockLocalRepository.baseEntities()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarBaseEntities(),
      expect: () => [const BaseEntityLoading(), const BaseEntityErro('Falha ao carregar base entities.')],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'obterPorType emite [BaseEntityLoading, BaseEntityListLoaded] quando encontra entidades',
      setUp: () {
        when(() => mockLocalRepository.obterPorType('PJ')).thenAnswer((_) async => Success([baseEntityFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorType('PJ'),
      expect: () => [
        const BaseEntityLoading(),
        BaseEntityListLoaded([baseEntityFixture]),
      ],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'obterPorId emite [BaseEntityLoading, BaseEntityLoaded] quando entidade existe',
      setUp: () {
        when(() => mockLocalRepository.obterPorId('entity-001')).thenAnswer((_) async => Success(baseEntityFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('entity-001'),
      expect: () => [const BaseEntityLoading(), BaseEntityLoaded(baseEntityFixture)],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'obterPorDocNumber emite [BaseEntityLoading, BaseEntityLoaded] quando entidade existe',
      setUp: () {
        when(
          () => mockLocalRepository.obterPorDocNumber('12345678000199'),
        ).thenAnswer((_) async => Success(baseEntityFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorDocNumber('12345678000199'),
      expect: () => [const BaseEntityLoading(), BaseEntityLoaded(baseEntityFixture)],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'obterPorId emite [BaseEntityLoading, BaseEntityErro] quando entidade não existe',
      setUp: () {
        when(() => mockLocalRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('entity-999'),
      expect: () => [const BaseEntityLoading(), const BaseEntityErro('Base entity não encontrada.')],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'gravar emite [BaseEntityLoading, BaseEntityGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(baseEntityFixture),
      expect: () => [const BaseEntityLoading(), const BaseEntityGravadoSucesso()],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'alterar emite [BaseEntityLoading, BaseEntityAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockLocalRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(baseEntityFixture),
      expect: () => [const BaseEntityLoading(), const BaseEntityAlteradoSucesso()],
    );
  });
}
