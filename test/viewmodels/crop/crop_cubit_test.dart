import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/crop_local_repository.dart';
import 'package:farmtracker/domains/models/crop_model.dart';
import 'package:farmtracker/views/viewmodels/crop/crop_cubit.dart';
import 'package:farmtracker/views/viewmodels/crop/crop_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockCropLocalRepository extends Mock implements CropLocalRepository {}

class _FakeCropModel extends Fake implements CropModel {}

void main() {
  late _MockCropLocalRepository mockRepository;

  final cropFixture = CropModel(
    id: 'crop-001',
    name: 'Soja',
    orgOwner: 'org-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  setUpAll(() {
    registerFallbackValue(_FakeCropModel());
  });

  setUp(() {
    mockRepository = _MockCropLocalRepository();
  });

  CropCubit buildCubit() => CropCubit(mockRepository);

  group('CropCubit', () {
    test('estado inicial é CropInitial', () {
      expect(buildCubit().state, const CropInitial());
    });

    blocTest<CropCubit, CropState>(
      'carregarCrops emite [CropLoading, CropListLoaded] quando há dados',
      setUp: () {
        when(() => mockRepository.crops()).thenAnswer((_) async => Success([cropFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarCrops(),
      expect: () => [
        const CropLoading(),
        CropListLoaded([cropFixture]),
      ],
    );

    blocTest<CropCubit, CropState>(
      'carregarCrops emite [CropLoading, CropErro] quando repositório falha',
      setUp: () {
        when(() => mockRepository.crops()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarCrops(),
      expect: () => [
        const CropLoading(),
        const CropErro('Falha ao carregar crops.'),
      ],
    );

    blocTest<CropCubit, CropState>(
      'obterPorName emite [CropLoading, CropListLoaded] quando encontra crops',
      setUp: () {
        when(() => mockRepository.obterPorName('So')).thenAnswer((_) async => Success([cropFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorName('So'),
      expect: () => [
        const CropLoading(),
        CropListLoaded([cropFixture]),
      ],
    );

    blocTest<CropCubit, CropState>(
      'obterPorId emite [CropLoading, CropLoaded] quando crop existe',
      setUp: () {
        when(() => mockRepository.obterPorId('crop-001', 'org-001')).thenAnswer((_) async => Success(cropFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('crop-001', 'org-001'),
      expect: () => [
        const CropLoading(),
        CropLoaded(cropFixture),
      ],
    );

    blocTest<CropCubit, CropState>(
      'obterPorId emite [CropLoading, CropErro] quando crop não existe',
      setUp: () {
        when(() => mockRepository.obterPorId(any(), any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('crop-999', 'org-001'),
      expect: () => [
        const CropLoading(),
        const CropErro('Crop não encontrado.'),
      ],
    );

    blocTest<CropCubit, CropState>(
      'gravar emite [CropLoading, CropGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(cropFixture),
      expect: () => [
        const CropLoading(),
        const CropGravadoSucesso(),
      ],
    );

    blocTest<CropCubit, CropState>(
      'alterar emite [CropLoading, CropAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(cropFixture),
      expect: () => [
        const CropLoading(),
        const CropAlteradoSucesso(),
      ],
    );
  });
}
