import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/core/usercase/usecase.dart';
import 'package:tdd_tutorial/src/core/utils/typedef.dart';
import '../entities/user.dart';
import '../repositories/authentication_repository.dart';

class LoginUserUsecase extends UsecaseWithParams<User, LoginUserParams> {
  LoginUserUsecase({required this.repository});
  final AuthenticationRepository repository;

  @override
  ResultFuture<User> call(LoginUserParams params) async {
    return await repository.loginUser(
        email: params.email, password: params.password);
  }
//dependency injection
}

class LoginUserParams extends Equatable {
  const LoginUserParams({required this.email, required this.password});

  const LoginUserParams.emptyUserParameters()
      : this(email: 'empty.email', password: 'empty.password');

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
