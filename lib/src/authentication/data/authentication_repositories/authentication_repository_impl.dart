import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/core/error/exception.dart';
import 'package:tdd_tutorial/src/core/error/failure.dart';
import '../../../core/utils/typedef.dart';
import '../../domain/entities/user.dart';
import '../data_source/auth_local_data_src.dart';

class AuthRepoImpl implements AuthenticationRepository {
  AuthRepoImpl(this._dataSrc, this._localDataSrc);

  final AuthRemoteDataSrc _dataSrc;
  final AuthLocalDataSrc _localDataSrc;

  @override
  ResultFuture<User> loginUser(
      {required String email, required String password}) async {
    try {
      final result = await _dataSrc.loginUser(email: email, password: password);
      return Right(result);
    } on ApiException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultVoid logoutUser() async {
    try {
      final result = await _localDataSrc.logoutUser();
      return Right(result);
    } on LocalException catch (e) {
      return Left(LocalFailure.fromException(e));
    }
  }

  @override
  ResultFuture<User> getCachedUser() async {
    try {
      final result = await _localDataSrc.getCachedUser();
      return Right(result);
    } on LocalException catch (e) {
      return Left(LocalFailure.fromException(e));
    }
  }

  @override
  ResultVoid cacheUserData(
      {required String name, required String email}) async {
    try {
      final result =
          await _localDataSrc.cacheUserData(name: name, email: email);
      return Right(result);
    } on LocalException catch (e) {
      return Left(LocalFailure.fromException(e));
    }
  }
}
