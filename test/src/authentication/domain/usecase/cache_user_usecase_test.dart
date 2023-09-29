//Things on which it depends
// autherpository is the thing on which it depends
//how to Mock it
// using mocktail
import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/cache_user_usecase.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late CacheUserUsecase usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = CacheUserUsecase(repository);
  });
  const params = CacheUserParams.emptyUserParameters();
  test('should call [AuthRepo.loginUser]', () async {
    //Arrange
    when(() => repository.cacheUserData(name: params.name, email: params.email))
        .thenAnswer((_) async => const Right(null));

    //Act
    final result = await usecase(params);

    //Assert

    expect(result, equals(const Right(null)));
    verify(() =>
            repository.cacheUserData(name: params.name, email: params.email))
        .called(1);
    verifyNoMoreInteractions(repository);
  });
}
