import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tdd_tutorial/src/core/error/exception.dart';
import 'package:tdd_tutorial/src/core/utils/constants.dart';
import '../../../core/utils/typedef.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSrc {
  Future<UserModel> loginUser(
      {required String email, required String password});
}

const kCreateUser = '/users';
const kGetUsers = '/users';
const KLoginUser = '/api/authaccount/login';

class AuthRemoteDataSrcImpl implements AuthRemoteDataSrc {
  AuthRemoteDataSrcImpl(this._client);
  final http.Client _client;

  @override
  Future<UserModel> loginUser(
      {required String email, required String password}) async {
    try {
      final response = await _client.post(Uri.parse('$kBaseUrl$KLoginUser'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
            message: response.body, statusCode: response.statusCode);
      } else {
        final userData = jsonDecode(response.body) as DataMap;
        if (userData['data'] == null) {
          return const UserModel.empty();
        } else {
          final user = UserModel.fromMap(userData);
          return user;
        }
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }
}
