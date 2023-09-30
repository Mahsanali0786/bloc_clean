import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/data/authentication_repositories/authentication_repository_impl.dart';
import 'package:tdd_tutorial/src/authentication/data/data_source/auth_local_data_src.dart';
import 'package:tdd_tutorial/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/core/error/exception.dart';
import 'package:tdd_tutorial/src/core/error/failure.dart';
import 'package:test/test.dart';

class MockAuthRemoteDataSrc extends Mock implements AuthRemoteDataSrc {}

class MockAuthLocalDataSrc extends Mock implements AuthLocalDataSrc {}

void main() {
  late AuthRemoteDataSrc remoteDataSrc;
  late AuthRepoImpl authRepoImpl;
  late AuthLocalDataSrc localDataSrc;

  setUp(() {
    remoteDataSrc = MockAuthRemoteDataSrc();
    localDataSrc = MockAuthLocalDataSrc();
    authRepoImpl = AuthRepoImpl(remoteDataSrc, localDataSrc);
  });

  const tException = ApiException(message: 'unknown error', statusCode: 500);

  const tUserModel = UserModel.empty();
  group('loginUser', () {
    test(
        'should return a correct data on when call is successful on [RemoteDataSource]',
        () async {
      when(() => remoteDataSrc.loginUser(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => Future.value(tUserModel));

      final result = await authRepoImpl.loginUser(
          email: tUserModel.email, password: tUserModel.password);

      //dependency

      verify(() => remoteDataSrc.loginUser(
          email: tUserModel.email, password: tUserModel.password)).called(1);
      expect(result, equals(const Right(tUserModel)));

      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return [ApiFailure] when call to remote_data_source is unsuccessful',
        () async {
      when(() => remoteDataSrc.loginUser(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenThrow(tException);

      final result = await authRepoImpl.loginUser(
          email: tUserModel.email, password: tUserModel.password);

      verify(() => remoteDataSrc.loginUser(
          email: tUserModel.email, password: tUserModel.password));
      expect(
          result,
          equals(Left(APIFailure(
              errorMessage: tException.message,
              statusCode: tException.statusCode))));
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('logoutUser', () {
    test(
        'should return a correct data on when call is successful on [RemoteDataSource]',
        () async {
      when(() => localDataSrc.logoutUser())
          .thenAnswer((_) async => Future.value());

      final result = localDataSrc.logoutUser;

      //dependency

      expect(result(), completes);
      verify(() => localDataSrc.logoutUser()).called(1);

      verifyNoMoreInteractions(localDataSrc);
    });

    test(
        'should return [ApiFailure] when call to remote_data_source is unsuccessful',
        () async {
      when(() => remoteDataSrc.loginUser(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenThrow(tException);

      final result = await authRepoImpl.loginUser(
          email: tUserModel.email, password: tUserModel.password);

      verify(() => remoteDataSrc.loginUser(
          email: tUserModel.email, password: tUserModel.password));
      expect(
          result,
          equals(Left(APIFailure(
              errorMessage: tException.message,
              statusCode: tException.statusCode))));
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });
}
