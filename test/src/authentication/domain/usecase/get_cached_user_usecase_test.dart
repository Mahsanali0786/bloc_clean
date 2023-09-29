//Things on which it depends
// autherpository is the thing on which it depends
//how to Mock it
// using mocktail
import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/get_cached_user_usecase.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late GetCachedUserUsecase usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetCachedUserUsecase(repository: repository);
  });
  const tUser = User.emptyUser();
  test('should call [AuthRepo.loginUser]', () async {
    //Arrange
    when(() => repository.getCachedUser()).thenAnswer((_) async=> const Right(tUser));

    //Act
    final result = await usecase();

    //Assert

    expect(result, equals(const Right(tUser)));
    verify(() => repository.getCachedUser()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
