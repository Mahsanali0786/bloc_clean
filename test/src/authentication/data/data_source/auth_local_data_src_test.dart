import 'dart:convert';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_tutorial/src/authentication/data/data_source/auth_local_data_src.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/core/error/exception.dart';
import 'package:test/test.dart';

class MockSharePrefrences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences sharedPreferences;
  late AuthLocalDataSrcImpl localDataSrcImpl;

  setUp(() {
    sharedPreferences = MockSharePrefrences();
    localDataSrcImpl = AuthLocalDataSrcImpl(sharedPreferences);
  });

  const tUserModel = UserModel.empty();

  String tUserData = '"userData"';
  const name = 'name';
  const email = 'email';
  String tUser = jsonEncode({
    'data': {'Name': name, 'Email': email}
  });
  group('CacheUserData', () {
    test('should complete successfully when data is cached ', () {
      when(() => sharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      final method = localDataSrcImpl.cacheUserData;

      expect(method(name: name, email: email), completes);
      verify(() => sharedPreferences.setString(tUserData, tUser));
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('should throw [LocalException] when unSuccessfully', () {
      when(() => sharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => false);
      final method = localDataSrcImpl.cacheUserData;

      expect(
          () async => method(name: name, email: email),
          throwsA(const LocalException(
              message: 'Data is not saved', statusCode: 400)));
      verify(() => sharedPreferences.setString(tUserData, tUser));
      verifyNoMoreInteractions(sharedPreferences);
    });
  });

  group('getCachedUser', () {
    test('should return [UserModel] with correct data when successful',
        () async {
      when(() => sharedPreferences.getString(any()))
          .thenReturn(tUserModel.toJson());

      final result = await localDataSrcImpl.getCachedUser();

      expect(result, equals(tUserModel));
      verify(() => sharedPreferences.getString(tUserData));
      verifyNoMoreInteractions(sharedPreferences);
    });

    const tLocalException = LocalException(
        message: 'Error occurred while getting User', statusCode: 400);

    test('should return LocalException when failure', () async {
      when(() => sharedPreferences.getString(any())).thenAnswer((_) => null);

      final result = localDataSrcImpl.getCachedUser;

      expect(() async => result(), throwsA(tLocalException));
      verify(() => sharedPreferences.getString(tUserData));
      verifyNoMoreInteractions(sharedPreferences);
    });
  });
}
