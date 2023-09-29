import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import '../../../core/utils/typedef.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultVoid cacheUserData({required String name,required String email});
  ResultFuture<User> getCachedUser();
  ResultVoid logoutUser();
  ResultFuture<User> loginUser({
    required String email,
    required String password,
  });
}
