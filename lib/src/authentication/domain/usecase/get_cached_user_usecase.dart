import 'package:tdd_tutorial/src/core/usercase/usecase.dart';
import 'package:tdd_tutorial/src/core/utils/typedef.dart';

import '../entities/user.dart';
import '../repositories/authentication_repository.dart';

class GetCachedUserUsecase extends UsecaseWithoutParams<User> {
  const GetCachedUserUsecase({required this.repository});

  final AuthenticationRepository repository;

  @override
  ResultFuture<User> call() async {
    return await repository.getCachedUser();
  }
}
