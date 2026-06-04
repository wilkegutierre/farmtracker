import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/base_entity_local_repository.dart';
import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:farmtracker/views/viewmodels/base_entity/base_entity_cubit.dart';
import 'package:farmtracker/views/viewmodels/base_entity/base_entity_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockBaseEntityLocalRepository extends Mock implements BaseEntityLocalRepository {}

class _FakeBaseEntityResponseModel extends Fake implements BaseEntityResponseModel {}

void main() {
  late _MockBaseEntityLocalRepository mockRepository;

  final baseEntityFixture = BaseEntityResponseModel(
    id: 'entity-001',
    orgOwner: 'org-001',
    name: 'Fazenda Boa Vista',
    type: 'PJ',
    docNumber: '12345678000199',
  );

  setUpAll(() {
    registerFallbackValue(_FakeBaseEntityResponseModel());
  });

  setUp(() {
    mockRepository = _MockBaseEntityLocalRepository();
  });

  BaseEntityCubit buildCubit() => BaseEntityCubit(mockRepository);

  group('BaseEntityCubit', () {
    test('estado inicial é BaseEntityInitial', () {
      expect(buildCubit().state, const BaseEntityInitial());
    });

    blocTest<BaseEntityCubit, BaseEntityState>(
      'carregarBaseEntities emite [BaseEntityLoading, BaseEntityListLoaded] quando há dados',
      setUp: () {
        when(() => mockRepository.baseEntities()).thenAnswer((_) async => Success([baseEntityFixture]));
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
        when(() => mockRepository.baseEntities()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarBaseEntities(),
      expect: () => [
        const BaseEntityLoading(),
        const BaseEntityErro('Falha ao carregar base entities.'),
      ],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'obterPorType emite [BaseEntityLoading, BaseEntityListLoaded] quando encontra entidades',
      setUp: () {
        when(() => mockRepository.obterPorType('PJ')).thenAnswer((_) async => Success([baseEntityFixture]));
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
        when(() => mockRepository.obterPorId('entity-001')).thenAnswer((_) async => Success(baseEntityFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('entity-001'),
      expect: () => [
        const BaseEntityLoading(),
        BaseEntityLoaded(baseEntityFixture),
      ],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'obterPorDocNumber emite [BaseEntityLoading, BaseEntityLoaded] quando entidade existe',
      setUp: () {
        when(() => mockRepository.obterPorDocNumber('12345678000199')).thenAnswer((_) async => Success(baseEntityFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorDocNumber('12345678000199'),
      expect: () => [
        const BaseEntityLoading(),
        BaseEntityLoaded(baseEntityFixture),
      ],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'obterPorId emite [BaseEntityLoading, BaseEntityErro] quando entidade não existe',
      setUp: () {
        when(() => mockRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('entity-999'),
      expect: () => [
        const BaseEntityLoading(),
        const BaseEntityErro('Base entity não encontrada.'),
      ],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'gravar emite [BaseEntityLoading, BaseEntityGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(baseEntityFixture),
      expect: () => [
        const BaseEntityLoading(),
        const BaseEntityGravadoSucesso(),
      ],
    );

    blocTest<BaseEntityCubit, BaseEntityState>(
      'alterar emite [BaseEntityLoading, BaseEntityAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(baseEntityFixture),
      expect: () => [
        const BaseEntityLoading(),
        const BaseEntityAlteradoSucesso(),
      ],
    );
  });
}
