import 'package:tdd_tutorial/src/core/usercase/usecase.dart';
import 'package:tdd_tutorial/src/core/utils/typedef.dart';

import '../repositories/authentication_repository.dart';

class LogoutUserUsecase extends UsecaseWithoutParams<void> {
  const LogoutUserUsecase(this.repository);
  final AuthenticationRepository repository;
  @override
  ResultFuture<void> call() async {
    return await repository.logoutUser();
  }
}
