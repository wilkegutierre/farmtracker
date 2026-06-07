import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/repositories/user_local_repository.dart';
import 'package:farmtracker/databases/models/response/user_response_model.dart';
import 'package:farmtracker/views/cubits/user/user_cubit.dart';
import 'package:farmtracker/views/cubits/user/user_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class _MockUserLocalRepository extends Mock implements UserLocalRepository {}

class _FakeUserResponseModel extends Fake implements UserResponseModel {}

void main() {
  late _MockUserLocalRepository mockRepository;

  final userFixture = UserResponseModel(
    id: 'user-001',
    email: 'usuario@test.com',
    phone: '11999990000',
    addressId: 'address-001',
  );

  setUpAll(() {
    registerFallbackValue(_FakeUserResponseModel());
  });

  setUp(() {
    mockRepository = _MockUserLocalRepository();
  });

  UserCubit buildCubit() => UserCubit(mockRepository);

  group('UserCubit', () {
    test('estado inicial é UserInitial', () {
      expect(buildCubit().state, const UserInitial());
    });

    blocTest<UserCubit, UserState>(
      'carregarUsers emite [UserLoading, UserListLoaded] quando há dados',
      setUp: () {
        when(() => mockRepository.users()).thenAnswer((_) async => Success([userFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarUsers(),
      expect: () => [
        const UserLoading(),
        UserListLoaded([userFixture]),
      ],
    );

    blocTest<UserCubit, UserState>(
      'carregarUsers emite [UserLoading, UserErro] quando repositório falha',
      setUp: () {
        when(() => mockRepository.users()).thenAnswer((_) async => Failure(SearchDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.carregarUsers(),
      expect: () => [const UserLoading(), const UserErro('Falha ao carregar users.')],
    );

    blocTest<UserCubit, UserState>(
      'obterPorAddressId emite [UserLoading, UserListLoaded] quando encontra users',
      setUp: () {
        when(() => mockRepository.obterPorAddressId('address-001')).thenAnswer((_) async => Success([userFixture]));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorAddressId('address-001'),
      expect: () => [
        const UserLoading(),
        UserListLoaded([userFixture]),
      ],
    );

    blocTest<UserCubit, UserState>(
      'obterPorId emite [UserLoading, UserLoaded] quando user existe',
      setUp: () {
        when(() => mockRepository.obterPorId('user-001')).thenAnswer((_) async => Success(userFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('user-001'),
      expect: () => [const UserLoading(), UserLoaded(userFixture)],
    );

    blocTest<UserCubit, UserState>(
      'obterPorEmail emite [UserLoading, UserLoaded] quando user existe',
      setUp: () {
        when(() => mockRepository.obterPorEmail('usuario@test.com')).thenAnswer((_) async => Success(userFixture));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorEmail('usuario@test.com'),
      expect: () => [const UserLoading(), UserLoaded(userFixture)],
    );

    blocTest<UserCubit, UserState>(
      'obterPorId emite [UserLoading, UserErro] quando user não existe',
      setUp: () {
        when(() => mockRepository.obterPorId(any())).thenAnswer((_) async => Failure(NotFoundDataBaseError()));
      },
      build: buildCubit,
      act: (cubit) => cubit.obterPorId('user-999'),
      expect: () => [const UserLoading(), const UserErro('User não encontrado.')],
    );

    blocTest<UserCubit, UserState>(
      'gravar emite [UserLoading, UserGravadoSucesso] quando gravação é bem-sucedida',
      setUp: () {
        when(() => mockRepository.gravar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.gravar(userFixture),
      expect: () => [const UserLoading(), const UserGravadoSucesso()],
    );

    blocTest<UserCubit, UserState>(
      'alterar emite [UserLoading, UserAlteradoSucesso] quando alteração é bem-sucedida',
      setUp: () {
        when(() => mockRepository.alterar(any())).thenAnswer((_) async => const Success(true));
      },
      build: buildCubit,
      act: (cubit) => cubit.alterar(userFixture),
      expect: () => [const UserLoading(), const UserAlteradoSucesso()],
    );
  });
}
