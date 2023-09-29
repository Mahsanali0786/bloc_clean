import 'dart:convert';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import '../../../core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSrc {
  Future<void> cacheUserData({required String name, required String email});
  Future<UserModel> getCachedUser(String key);
  Future<void> logoutUser();
}

class AuthLocalDataSrcImpl extends AuthLocalDataSrc {
  String userData = '"userData"';

  AuthLocalDataSrcImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheUserData(
      {required String name, required String email}) async {
    try {
      String user = jsonEncode({'data':{'name': name, 'email': email}});
      final response = await sharedPreferences.setString(userData, user);

      if (response != true) {
        throw const LocalException(message: 'Data is not saved', statusCode: 400);
      }
    } on LocalException {
      rethrow;
    } catch (e) {
      throw LocalException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<UserModel> getCachedUser(String key) async {
    try {
      final response = sharedPreferences.getString(key);

      if (response == null || response == '') {
        throw const LocalException(
            message: 'Error occurred while getting User', statusCode: 400);
      } else {
        return UserModel.fromJson(response);
      }
    } on LocalException {
      rethrow;
    } catch (e) {
      throw LocalException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      final response = await sharedPreferences.remove(userData);
      if (response != true) {
        throw const LocalException(
            message: 'Error occurred while getting User', statusCode: 500);
      }
    } on LocalException {
      rethrow;
    } catch (e) {
      throw LocalException(message: e.toString(), statusCode: 505);
    }
  }
}
