import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/core/error/exception.dart';
import 'package:tdd_tutorial/src/core/utils/constants.dart';


class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AuthRemoteDataSrcImpl remoteDataSrcImpl;
  late http.Client client;

  setUp(() {
    client = MockHttpClient();
    remoteDataSrcImpl = AuthRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });
  const email = 'Developer5@gmail.com';
  const password = 'password';
  const tUserModel = UserModel.empty();
  group('createUser', () {
    test('should complete successfully when response is 200 or 201', () async {
      when(() => client.post(any(), body: any(named: 'body'),headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(tUserModel.toJson(), 201));

      final method =
          await remoteDataSrcImpl.loginUser(email: email, password: password);

      expect(method, equals(tUserModel));
      verify(
        () => client.post(
          Uri.parse('$kBaseUrl$KLoginUser'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: {'Content-Type': 'application/json'}
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test('should throw an [API exception] when response code is not 200 or 201',
        () {
      when(() => client.post(any(), body: any(named: 'body'),headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('invalid email', 400));

      final methodCalled = remoteDataSrcImpl.loginUser;

      expect(
          () async => methodCalled(email: email, password: password),
          throwsA(
              const ApiException(message: 'invalid email', statusCode: 400)));

      verify(
        () => client.post(
          Uri.parse('$kBaseUrl$KLoginUser'),
          body: jsonEncode(
            {'email': email, 'password': password},
          ),
            headers: {'Content-Type': 'application/json'}
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });
}
