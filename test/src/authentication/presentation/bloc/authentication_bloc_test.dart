import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/cache_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/get_cached_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/login_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/logout_user_usecase.dart';
import 'package:tdd_tutorial/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:tdd_tutorial/src/core/error/failure.dart';
import 'package:test/test.dart';

class MockGetCachedUserUsecase extends Mock implements GetCachedUserUsecase {}

class MockLoginUserUsecase extends Mock implements LoginUserUsecase {}

class MockLogoutUserUsecase extends Mock implements LogoutUserUsecase {}

class MockCacheUsecase extends Mock implements CacheUserUsecase {}

void main() {
  late GetCachedUserUsecase getUser;
  late LoginUserUsecase loginUser;
  late LogoutUserUsecase logoutUser;
  late CacheUserUsecase cacheUser;
  late AuthenticationBloc bloc;

  const tAPIFailure =
      APIFailure(errorMessage: 'error occurred', statusCode: 500);
  const tLocalFailure =
      LocalFailure(errorMessage: 'error occurred', statusCode: 500);

  setUp(() {
    getUser = MockGetCachedUserUsecase();
    loginUser = MockLoginUserUsecase();
    logoutUser = MockLogoutUserUsecase();
    cacheUser = MockCacheUsecase();
    bloc = AuthenticationBloc(
        getUser: getUser,
        cacheUser: cacheUser,
        login: loginUser,
        logout: logoutUser);
  });

  tearDown(() => bloc.close());

  // package?? bloc_test

  test('initial state should be [AuthenticationInitial]', () {
    expect(bloc.state, AuthenticationInitial());
  });
  const name = 'name';
  const password = 'password';
  const email = 'email';

  const user = User(name: name, email: email, password: password);

  group('LoginUser', () {
    const tUserLoginParams = LoginUserParams(email: email, password: password);
    registerFallbackValue(tUserLoginParams);

    blocTest('should emit [LoadingUserState,UserLoginState] when successful',
        build: () {
          when(() => loginUser(any()))
              .thenAnswer((_) async => const Right(user));

          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoginUserEvent(email: email, password: password)),
        expect: () => [const LoadingState(''), const LoginState(user)],
        verify: (_) {
          verify(() => loginUser(tUserLoginParams)).called(1);
          verifyNoMoreInteractions(loginUser);
        });
    blocTest(
        'should emit [creatingUser,AuthenticationErrorState] when there is any failure',
        build: () {
          when(() => loginUser(any()))
              .thenAnswer((_) async => const Left(tAPIFailure));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const LoginUserEvent(email: email, password: password)),
        expect: () => [
              const LoadingState('Logging In...'),
              AuthenticationErrorState(message: tAPIFailure.getErrorMessage)
            ],
        verify: (_) {
          verify(() => loginUser(tUserLoginParams)).called(1);
          verifyNoMoreInteractions(loginUser);
        });
  });
  group('LogoutUser', () {
    // const tUserLoginParams = LoginUserParams(email: email, password: password);
    // registerFallbackValue(tUserLoginParams);

    blocTest('should emit [LoadingUserState,LogoutUserState] when successful',
        build: () {
          when(() => logoutUser()).thenAnswer((_) async => const Right(null));

          return bloc;
        },
        act: (bloc) => bloc.add(LogoutUserEvent()),
        expect: () => [const LoadingState('Logout'), const LogoutUserState()],
        verify: (_) {
          verify(() => logoutUser()).called(1);
          verifyNoMoreInteractions(logoutUser);
        });
    blocTest(
        'should emit [LodingState,AuthenticationErrorState] when there is any failure',
        build: () {
          when(() => logoutUser())
              .thenAnswer((_) async => const Left(tLocalFailure));
          return bloc;
        },
        act: (bloc) => bloc.add(LogoutUserEvent()),
        expect: () => [
              const LoadingState('Logout'),
              AuthenticationErrorState(message: tLocalFailure.getErrorMessage)
            ],
        verify: (_) {
          verify(() => logoutUser()).called(1);
          verifyNoMoreInteractions(logoutUser);
        });

    group('CacheUser', () {
      const tCacheUserParams = CacheUserParams(name: name, email: email);
      registerFallbackValue(tCacheUserParams);

      blocTest('should emit [LoadingUserState,userLoadedState] when successful',
          build: () {
            when(() => cacheUser(any()))
                .thenAnswer((_) async => const Right(null));

            return bloc;
          },
          act: (bloc) =>
              bloc.add(const CacheUserEvent(name: name, email: email)),
          expect: () => [
                const LoadingState('Logging In...'),
                const UserLoadedState(user)
              ],
          verify: (_) {
            verify(() => cacheUser(tCacheUserParams)).called(1);
            verifyNoMoreInteractions(logoutUser);
          });
      blocTest(
          'should emit [LodingState,GetttingUserCacheErrorState] when there is any failure',
          build: () {
            when(() => cacheUser(any()))
                .thenAnswer((_) async => const Left(tLocalFailure));
            return bloc;
          },
          act: (bloc) =>
              bloc.add(const CacheUserEvent(name: name, email: email)),
          expect: () =>
              [const LoadingState('Logging In...'), GetCachedUserErrorState()],
          verify: (_) {
            verify(() => cacheUser(tCacheUserParams)).called(1);
            verifyNoMoreInteractions(logoutUser);
          });
    });

    group('GetCachedUser', () {
      // const tCacheUserParams = CacheUserParams(name: name, email: email);
      // registerFallbackValue(tCacheUserParams);

      blocTest('should emit [LoadingUserState,userLoadedState] when successful',
          build: () {
            when(() => getUser()).thenAnswer((_) async => const Right(user));

            return bloc;
          },
          act: (bloc) => bloc.add(GetCachedUserEvent()),
          expect: () =>
              [const LoadingState('Loading data'), const UserLoadedState(user)],
          verify: (_) {
            verify(() => getUser()).called(1);
            verifyNoMoreInteractions(getUser);
          });
      blocTest(
          'should emit [LodingState,AuthenticationErrorState] when there is any failure',
          build: () {
            when(() => getUser())
                .thenAnswer((_) async => const Left(tLocalFailure));
            return bloc;
          },
          act: (bloc) => bloc.add(GetCachedUserEvent()),
          expect: () =>
              [const LoadingState('Logging In...'), GetCachedUserErrorState()],
          verify: (_) {
            verify(() => getUser()).called(1);
            verifyNoMoreInteractions(getUser);
          });
    });
  });
}
