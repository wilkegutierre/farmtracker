import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/errors/http_error.dart';
import 'package:farmtracker/databases/local/repositories/type_visit_local_repository.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:farmtracker/domains/repositories/type_visit/type_visit_repository.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_cubit.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockTypeVisitRepository extends Mock implements TypeVisitRepository {}

class _MockTypeVisitLocalRepository extends Mock implements TypeVisitLocalRepository {}

class _FakeTypeVisitResponseModel extends Fake implements TypeVisitResponseModel {}

void main() {
  late _MockTypeVisitRepository mockRemoteRepository;
  late _MockTypeVisitLocalRepository mockLocalRepository;

  final typeVisitFixture = TypeVisitResponseModel(
    id: 1,
    description: 'Monitoramento',
    orgOwner: 'org-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  final customerFixture = CustomerResponseModel(id: 'customer-001', orgOwner: 'org-001');

  setUpAll(() {
    registerFallbackValue(_FakeTypeVisitResponseModel());
  });

  setUp(() {
    mockRemoteRepository = _MockTypeVisitRepository();
    mockLocalRepository = _MockTypeVisitLocalRepository();
  });

  TypeVisitCubit buildCubit() => TypeVisitCubit(mockRemoteRepository, mockLocalRepository);

  group('TypeVisitCubit', () {
    test('estado inicial é TypeVisitInitial', () {
      expect(buildCubit().state, const TypeVisitInitial());
    });

    blocTest<TypeVisitCubit, TypeVisitState>(
      'syncTypeVisits emite [TypeVisitLoading, TypeVisitListLoaded] e grava localmente quando há dados',
      setUp: () {
        when(() => mockRemoteRepository.getByOrgOwner('org-001')).thenAnswer((_) async => Success([typeVisitFixture]));
        when(
          () => mockLocalRepository.obterPorId(1, 'org-001'),
        ).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncTypeVisits('org-001'),
      expect: () => [
        const TypeVisitLoading(),
        TypeVisitListLoaded([typeVisitFixture]),
      ],
      verify: (_) {
        verify(() => mockRemoteRepository.getByOrgOwner('org-001')).called(1);
        verify(() => mockLocalRepository.gravar(typeVisitFixture)).called(1);
      },
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'syncTypeVisits atualiza registro local quando type visit já existe',
      setUp: () {
        when(() => mockRemoteRepository.getByOrgOwner('org-001')).thenAnswer((_) async => Success([typeVisitFixture]));
        when(() => mockLocalRepository.obterPorId(1, 'org-001')).thenAnswer((_) async => Success(typeVisitFixture));
        when(() => mockLocalRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncTypeVisits('org-001'),
      expect: () => [
        const TypeVisitLoading(),
        TypeVisitListLoaded([typeVisitFixture]),
      ],
      verify: (_) {
        verify(() => mockLocalRepository.alterar(typeVisitFixture)).called(1);
        verifyNever(() => mockLocalRepository.gravar(any()));
      },
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'syncTypeVisits emite [TypeVisitLoading, TypeVisitListLoaded] quando lista remota está vazia',
      setUp: () {
        when(() => mockRemoteRepository.getByOrgOwner('org-001')).thenAnswer((_) async => const Success([]));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncTypeVisits('org-001'),
      expect: () => [const TypeVisitLoading(), const TypeVisitListLoaded([])],
      verify: (_) {
        verifyNever(() => mockLocalRepository.gravar(any()));
        verifyNever(() => mockLocalRepository.alterar(any()));
      },
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'syncTypeVisits emite [TypeVisitLoading, TypeVisitErro] quando repositório remoto falha',
      setUp: () {
        when(() => mockRemoteRepository.getByOrgOwner(any())).thenAnswer((_) async => Failure(InternalServerError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncTypeVisits('org-001'),
      expect: () => [const TypeVisitLoading(), const TypeVisitErro('Falha ao carregar tipos de visita da API.')],
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'syncTypeVisits emite [TypeVisitLoading, TypeVisitErro] quando gravação local falha',
      setUp: () {
        when(() => mockRemoteRepository.getByOrgOwner('org-001')).thenAnswer((_) async => Success([typeVisitFixture]));
        when(
          () => mockLocalRepository.obterPorId(1, 'org-001'),
        ).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => Failure(InsertDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncTypeVisits('org-001'),
      expect: () => [const TypeVisitLoading(), const TypeVisitErro('Falha ao gravar tipos de visita localmente.')],
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'syncTypeVisitsByCustomers emite [TypeVisitLoading, TypeVisitListLoaded] e grava localmente quando há dados',
      setUp: () {
        when(() => mockRemoteRepository.getByOrgOwner('org-001')).thenAnswer((_) async => Success([typeVisitFixture]));
        when(
          () => mockLocalRepository.obterPorId(1, 'org-001'),
        ).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncTypeVisitsByCustomers('customer-001'),
      expect: () => [
        const TypeVisitLoading(),
        TypeVisitListLoaded([typeVisitFixture]),
      ],
      verify: (_) {
        verify(() => mockRemoteRepository.getByOrgOwner('org-001')).called(1);
        verify(() => mockLocalRepository.gravar(typeVisitFixture)).called(1);
      },
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'syncTypeVisitsByCustomers emite [TypeVisitLoading, TypeVisitErro] quando customers não possuem orgOwner',
      build: buildCubit,
      act: (cubit) => cubit.syncTypeVisitsByCustomers('customer-001'),
      expect: () => [
        const TypeVisitLoading(),
        const TypeVisitErro('Nenhuma organização encontrada para sincronizar tipos de visita.'),
      ],
      verify: (_) {
        verifyNever(() => mockRemoteRepository.getByOrgOwner(any()));
      },
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'syncTypeVisitsByCustomers emite [TypeVisitLoading, TypeVisitErro] quando repositório remoto falha',
      setUp: () {
        when(() => mockRemoteRepository.getByOrgOwner(any())).thenAnswer((_) async => Failure(InternalServerError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.syncTypeVisitsByCustomers('customer-001'),
      expect: () => [const TypeVisitLoading(), const TypeVisitErro('Falha ao carregar tipos de visita da API.')],
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'carregarTypeVisits emite [TypeVisitLoading, TypeVisitListLoaded] quando há dados',
      setUp: () {
        when(() => mockLocalRepository.typeVisits()).thenAnswer((_) async => Success([typeVisitFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarTypeVisits(),
      expect: () => [
        const TypeVisitLoading(),
        TypeVisitListLoaded([typeVisitFixture]),
      ],
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'carregarTypeVisits emite [TypeVisitLoading, TypeVisitErro] quando repositório falha',
      setUp: () {
        when(() => mockLocalRepository.typeVisits()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarTypeVisits(),
      expect: () => [const TypeVisitLoading(), const TypeVisitErro('Falha ao carregar tipos de visita.')],
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'obterPorId emite [TypeVisitLoading, TypeVisitLoaded] quando type visit existe',
      setUp: () {
        when(() => mockLocalRepository.obterPorId(1, 'org-001')).thenAnswer((_) async => Success(typeVisitFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId(1, 'org-001'),
      expect: () => [const TypeVisitLoading(), TypeVisitLoaded(typeVisitFixture)],
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'obterPorId emite [TypeVisitLoading, TypeVisitErro] quando type visit não existe',
      setUp: () {
        when(
          () => mockLocalRepository.obterPorId(any(), any()),
        ).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId(999, 'org-001'),
      expect: () => [const TypeVisitLoading(), const TypeVisitErro('Tipo de visita não encontrado.')],
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'gravar emite [TypeVisitLoading, TypeVisitGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockLocalRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(typeVisitFixture),
      expect: () => [const TypeVisitLoading(), const TypeVisitGravadoSucesso()],
    );

    blocTest<TypeVisitCubit, TypeVisitState>(
      'alterar emite [TypeVisitLoading, TypeVisitAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockLocalRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(typeVisitFixture),
      expect: () => [const TypeVisitLoading(), const TypeVisitAlteradoSucesso()],
    );
  });
}
