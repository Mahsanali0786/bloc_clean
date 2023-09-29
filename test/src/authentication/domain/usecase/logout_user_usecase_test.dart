//Things on which it depends
// autherpository is the thing on which it depends
//how to Mock it
// using mocktail

import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecase/logout_user_usecase.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late LogoutUserUsecase usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = LogoutUserUsecase(repository);
  });
  test("should call [AuthRepo.logout]", () async {
    //Arrange
    when(() => repository.logoutUser())
        .thenAnswer((_) async => const Right(null));

    //Act
    final result = await usecase();

    //Assert

    expect(result, equals(const Right(null)));
    verify(() => repository.logoutUser()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
