import 'dart:convert';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/core/utils/typedef.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  const tUserModel = UserModel.empty();

  test('should be the subclass of [User] Entity', () {
    //Arrange

    //Act

    //Assert

    expect(tUserModel, isA<User>());
  });

  String tJson = jsonData('user.json');
  DataMap tMap = jsonDecode(tJson) as DataMap;

  final userModel = UserModel(
      email: tMap['data']['Email'],
      name: tMap['data']['Name'],
      password:'password' );

  group('fromMap', () {
    test('should return a UserModel with right data', () {
      final result = UserModel.fromMap(tMap);

      expect(result, equals(userModel));
    });
  });

  group('fromJson', () {
    test('should return return a right UserModel', () {
      final result = UserModel.fromJson(tJson);

      expect(result, equals(userModel));
    });
  });

  group('toMap', () {
    test('should return a map of with true data', () {
      final result = tUserModel.toMap();

      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return [Json] with created at', () {
      final result = tUserModel.toJson();

      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return [UserModel] with updated values', () {
      final result = tUserModel.copyWith(name: 'ahsan');

      expect(result, isNot(tUserModel));
      expect(result.name, equals('ahsan'));
    });
  });
}
