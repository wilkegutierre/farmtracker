import 'package:bloc_test/bloc_test.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/databases/local/repositories/usuario_local_repository.dart';
import 'package:farmtracker/databases/models/request/login_user_request_model.dart';
import 'package:farmtracker/databases/models/response/usuario_response_model.dart';
import 'package:farmtracker/domains/models/auth_data.dart';
import 'package:farmtracker/domains/repositories/usuario/usuario_repository.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_cubit.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockUsuarioRepository extends Mock implements UsuarioRepository {}

class _MockUsuarioLocalRepository extends Mock implements UsuarioLocalRepository {}

class _MockSessionManagerRepository extends Mock implements SessionManagerRepository {}

class _FakeLoginRequest extends Fake implements LoginUserRequestModel {}

class _FakeAuthData extends Fake implements AuthData {}

void main() {
  late _MockUsuarioRepository mockRepo;
  late _MockUsuarioLocalRepository mockLocalRepo;
  late _MockSessionManagerRepository mockSessionManager;

  setUpAll(() {
    registerFallbackValue(_FakeLoginRequest());
    registerFallbackValue(_FakeAuthData());
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = _MockUsuarioRepository();
    mockLocalRepo = _MockUsuarioLocalRepository();
    mockSessionManager = _MockSessionManagerRepository();
  });

  UsuarioCubit buildCubit() =>
      UsuarioCubit(mockRepo, mockLocalRepo, mockSessionManager);

  final authDataValido = AuthData(
    token: 'token-valido-123',
    tokenType: 'Bearer',
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
  );

  group('UsuarioCubit —', () {
    test('estado inicial é UsuarioInitial', () {
      expect(buildCubit().state, const UsuarioInitial());
    });

    // ───────────── login ─────────────

    group('login()', () {
      blocTest<UsuarioCubit, UsuarioState>(
        'emite [UsuarioLoading, UsuarioLoginSuccess] quando credenciais são válidas',
        setUp: () {
          when(() => mockRepo.login(any()))
              .thenAnswer((_) async => Success(authDataValido));
          when(() => mockSessionManager.saveSession(any()))
              .thenAnswer((_) async {});
          when(() => mockLocalRepo.login(any()))
              .thenAnswer((_) async => const Success(true));
        },
        build: buildCubit,
        act: (cubit) => cubit.login('usuario@test.com', 'senha123'),
        expect: () => [
          const UsuarioLoading(),
          UsuarioLoginSuccess(authDataValido.token),
        ],
        verify: (_) {
          verify(() => mockRepo.login(any())).called(1);
          verify(() => mockSessionManager.saveSession(any())).called(1);
          verify(() => mockLocalRepo.login(any())).called(1);
        },
      );

      blocTest<UsuarioCubit, UsuarioState>(
        'emite [UsuarioLoading, UsuarioLoginFailure] quando repositório retorna falha',
        setUp: () {
          when(() => mockRepo.login(any()))
              .thenAnswer((_) async => Failure(Exception('Credenciais inválidas')));
        },
        build: buildCubit,
        act: (cubit) => cubit.login('usuario@test.com', 'senha_errada'),
        expect: () => [
          const UsuarioLoading(),
          isA<UsuarioLoginFailure>(),
        ],
        verify: (_) {
          verify(() => mockRepo.login(any())).called(1);
          verifyNever(() => mockLocalRepo.login(any()));
        },
      );

      blocTest<UsuarioCubit, UsuarioState>(
        'emite [UsuarioLoading, UsuarioLoginFailure] quando token retornado está vazio',
        setUp: () {
          final authComTokenVazio = AuthData(
            token: '',
            tokenType: 'Bearer',
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
          );
          when(() => mockRepo.login(any()))
              .thenAnswer((_) async => Success(authComTokenVazio));
          when(() => mockSessionManager.saveSession(any()))
              .thenAnswer((_) async {});
        },
        build: buildCubit,
        act: (cubit) => cubit.login('usuario@test.com', 'senha123'),
        expect: () => [
          const UsuarioLoading(),
          isA<UsuarioLoginFailure>(),
        ],
      );
    });

    // ───────────── setPassword ─────────────

    group('setPassword()', () {
      blocTest<UsuarioCubit, UsuarioState>(
        'emite [UsuarioLoading, UsuarioPasswordSuccess] quando senha é definida com sucesso',
        setUp: () {
          when(() => mockRepo.setPassword(any()))
              .thenAnswer((_) async => Success(authDataValido));
          when(() => mockSessionManager.saveSession(any()))
              .thenAnswer((_) async {});
        },
        build: buildCubit,
        act: (cubit) => cubit.setPassword('email@test.com', 'novaSenha123'),
        expect: () => [
          const UsuarioLoading(),
          const UsuarioPasswordSuccess(),
        ],
        verify: (_) {
          verify(() => mockRepo.setPassword(any())).called(1);
          verify(() => mockSessionManager.saveSession(any())).called(1);
        },
      );

      blocTest<UsuarioCubit, UsuarioState>(
        'emite [UsuarioLoading, UsuarioPasswordFailure] quando repositório retorna falha',
        setUp: () {
          when(() => mockRepo.setPassword(any()))
              .thenAnswer((_) async => Failure(Exception('Erro de servidor')));
        },
        build: buildCubit,
        act: (cubit) => cubit.setPassword('email@test.com', 'novaSenha123'),
        expect: () => [
          const UsuarioLoading(),
          isA<UsuarioPasswordFailure>(),
        ],
      );
    });

    // ───────────── isSessionValid ─────────────

    group('isSessionValid()', () {
      test('retorna true quando sessão é válida', () async {
        when(() => mockSessionManager.isSessionValid())
            .thenAnswer((_) async => true);

        final result = await buildCubit().isSessionValid();

        expect(result, isTrue);
      });

      test('retorna false quando sessão está expirada', () async {
        when(() => mockSessionManager.isSessionValid())
            .thenAnswer((_) async => false);

        final result = await buildCubit().isSessionValid();

        expect(result, isFalse);
      });
    });

    // ───────────── getUsuarioById ─────────────

    group('getUsuarioById()', () {
      blocTest<UsuarioCubit, UsuarioState>(
        'emite [UsuarioLoading, UsuarioLoaded] quando usuário é encontrado',
        setUp: () {
          final responseModel = UsuarioResponseModel(
            uuid: 'uuid-123',
            nome: 'João Silva',
            email: 'joao@test.com',
            telefone: '11999999999',
            senha: 'hash',
            foto: '',
            tokenAcesso: 'tok-123',
          );
          when(() => mockRepo.getUsuarioById(any()))
              .thenAnswer((_) async => Success(responseModel));
        },
        build: buildCubit,
        act: (cubit) => cubit.getUsuarioById('uuid-123'),
        expect: () => [
          const UsuarioLoading(),
          isA<UsuarioLoaded>(),
        ],
      );

      blocTest<UsuarioCubit, UsuarioState>(
        'emite [UsuarioLoading, UsuarioLoginFailure] quando usuário não é encontrado',
        setUp: () {
          when(() => mockRepo.getUsuarioById(any()))
              .thenAnswer((_) async => Failure(Exception('Não encontrado')));
        },
        build: buildCubit,
        act: (cubit) => cubit.getUsuarioById('uuid-invalido'),
        expect: () => [
          const UsuarioLoading(),
          isA<UsuarioLoginFailure>(),
        ],
      );
    });
  });
}
