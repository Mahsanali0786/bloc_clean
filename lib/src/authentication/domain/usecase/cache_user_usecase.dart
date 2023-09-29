import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/core/usercase/usecase.dart';
import 'package:tdd_tutorial/src/core/utils/typedef.dart';

class CacheUserUsecase extends UsecaseWithParams<void, CacheUserParams> {
  const CacheUserUsecase(this.repository);
  final AuthenticationRepository repository;
  @override
  ResultFuture<void> call(CacheUserParams params) async {
    return await repository.cacheUserData(
        name: params.name, email: params.email);
  }
}

class CacheUserParams extends Equatable {
  const CacheUserParams(
      {required this.name, required this.email});

  const CacheUserParams.emptyUserParameters()
      : this(
            name: 'empty.name',
            email: 'empty.email',);

  final String name;
  final String email;

  @override
  List<Object?> get props => [name, email];
}
